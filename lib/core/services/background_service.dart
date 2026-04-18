import 'package:novon/core/common/enums/novel_refresh_results.dart';
import 'package:workmanager/workmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'backup_service.dart';
import 'storage_path_service.dart';
import 'extension_loader.dart';
import 'extension_engine.dart';
import 'novel_metadata_service.dart';
import '../data/repositories/novel_repository_impl.dart';
import '../data/repositories/chapter_repository_impl.dart';
import '../data/database/database.dart';
import 'package:novon/core/common/constants/worker_constants.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import 'exception_logger_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // 1. Resolve storage path via shared_preferences
      final sps = StoragePathService.instance;
      await sps.init();

      final String hivePath;
      if (sps.isConfigured) {
        await sps.ensureDirectoriesExist();
        hivePath = sps.hiveDir;
      } else {
        hivePath = await sps.getFallbackPath();
      }

      // 2. Initialize Hive in the same location as the foreground app.
      await Hive.initFlutter(hivePath);
      await Hive.openBox(HiveBox.app);
      await Hive.openBox(HiveBox.reader);
      await Hive.openBox(HiveBox.exceptions);
      await Hive.openBox(HiveBox.removedNovels);

      // 3. Open Drift DB in the same location.
      final dbPath = sps.isConfigured
          ? sps.storagePath!
          : await sps.getFallbackPath();
      final db = AppDatabase(dbPath);

      switch (task) {
        case WorkerConstants.taskAutoBackup:
          final backupService = BackupService(db, sps);
          await backupService.createBackup();
          break;
        case WorkerConstants.taskUpdateLibrary:
          final libraryNovels = await db.select(db.novels).get();
          final inLibNovels = libraryNovels.where((n) => n.inLibrary).toList();
          if (inLibNovels.isEmpty) break;

          final extLoader = ExtensionLoader.instance;
          final installedExts = await extLoader.discoverAll();
          final engine = ExtensionEngine.instance;

          final novelRepo = NovelRepositoryImpl(db);
          final chapterRepo = ChapterRepositoryImpl(db);

          final box = Hive.box(HiveBox.app);
          final pendingRaw = box.get(
            HiveKeys.notifChapterUpdates,
            defaultValue: <String>[],
          );
          final pendingUpdates = (pendingRaw as Iterable)
              .map((e) => e.toString())
              .toSet();
          bool hasNewUpdates = false;

          for (final novel in inLibNovels) {
            try {
              final manifest = installedExts
                  .where((m) => m.id == novel.sourceId)
                  .firstOrNull;
              if (manifest == null) continue;

              final storagePath = sps.isConfigured
                  ? sps.storagePath!
                  : await sps.getFallbackPath();
              final sourceFile = File(
                '$storagePath/extensions/${manifest.id}/source.js',
              );
              if (!await sourceFile.exists()) continue;

              final scriptSource = await sourceFile.readAsString();

              Map<String, dynamic> freshDetail = {};
              List<dynamic> freshChapters = [];

              await Future.wait([
                () async {
                  try {
                    final raw = await engine.fetchNovelDetail(
                      novel.sourceId,
                      scriptSource,
                      novel.url,
                    );
                    freshDetail = Map<String, dynamic>.from(raw as Map);
                  } catch (_) {}
                }(),
                () async {
                  try {
                    final raw = await engine.fetchChapterList(
                      novel.sourceId,
                      scriptSource,
                      novel.url,
                    );
                    freshChapters = List<dynamic>.from(raw as Iterable);
                  } catch (_) {}
                }(),
              ]);

              final result = await NovelMetadataService.instance
                  .refreshIfInLibrary(
                    novelUrl: novel.id,
                    novelRepo: novelRepo,
                    chapterRepo: chapterRepo,
                    freshDetail: freshDetail,
                    freshChapters: freshChapters,
                  );

              if (result == NovelRefreshResult.newChapters) {
                // Determine which ones are newly added.
                // We've already updated the database via the service, so we can't easily tell exactly which IDs were added just now from the service's return value.
                // However, we just know there are new ones.
                // Since this is a global flag, we can just record the novel itself has updates.
                pendingUpdates.add(novel.id);
                hasNewUpdates = true;
              }
            } catch (e) {
              if (kDebugMode) {
                print('Update Library background error for ${novel.title}: $e');
              }
              continue;
            }
          }

          if (hasNewUpdates) {
            await box.put(
              HiveKeys.notifChapterUpdates,
              pendingUpdates.toList(),
            );
          }
          engine.disposeAll();
          break;
        case WorkerConstants.taskCheckExtensions:
          await Hive.openBox(HiveBox.extensions);
          final extLoader = ExtensionLoader.instance;
          final installed = await extLoader.discoverAll();
          await extLoader.checkForUpdates(installed);
          break;
        case WorkerConstants.taskPruneLogs:
          await ExceptionLoggerService.instance.pruneOldLogs();
          break;
        case WorkerConstants.taskPruneRemovedNovels:
          await _pruneRemovedNovels(db);
          break;
      }

      await db.close();
      return Future.value(true);
    } catch (err) {
      if (kDebugMode) print('Background Task Error: $err');
      return Future.value(false);
    }
  });
}

/// Prune data (chapters + cover images) for novels that were removed from library
/// more than [graceDays] ago.
Future<void> _pruneRemovedNovels(AppDatabase db, {int graceDays = 3}) async {
  final expired = NovelMetadataService.getExpiredRemovedNovels(
    graceDays: graceDays,
  );
  if (expired.isEmpty) return;

  final sps = StoragePathService.instance;

  for (final novelId in expired) {
    try {
      // 1. Delete cached chapter content (SQLite).
      await db.customStatement(
        'DELETE FROM chapter_contents WHERE chapter_id IN (SELECT id FROM chapters WHERE novel_id = ?)',
        [novelId],
      );
      // 2. Delete chapter rows.
      await (db.delete(
        db.chapters,
      )..where((t) => t.novelId.equals(novelId))).go();
      // 3. Delete the novel row itself (it's no longer in library, safe to remove).
      await (db.delete(db.novels)..where((t) => t.id.equals(novelId))).go();
      // 4. Delete local cover file.
      if (sps.isConfigured) {
        final safeId = Uri.encodeComponent(novelId).replaceAll('%', '_');
        for (final ext in ['.jpg', '.png', '.webp', '.gif']) {
          try {
            final f = File('${sps.coversDir}/$safeId$ext');
            await sps.placeNomediaFile(sps.coversDir);
            if (await f.exists()) await f.delete();
          } catch (_) {}
        }
      }
    } catch (e) {
      if (kDebugMode) print('[_pruneRemovedNovels] error for $novelId: $e');
    }
  }

  // 5. Remove pruned entries from the index.
  NovelMetadataService.clearExpiredFromIndex(expired);
}

class BackgroundService {
  static void registerAutoBackup() {
    Workmanager().registerPeriodicTask(
      WorkerConstants.idAutoBackup,
      WorkerConstants.taskAutoBackup,
      frequency: const Duration(days: 1),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
      ),
    );
  }

  static void registerLibraryUpdate() {
    Workmanager().registerPeriodicTask(
      WorkerConstants.idUpdateLibrary,
      WorkerConstants.taskUpdateLibrary,
      frequency: const Duration(hours: 6),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  static void registerPruneLogs() {
    Workmanager().registerPeriodicTask(
      WorkerConstants.idPruneLogs,
      WorkerConstants.taskPruneLogs,
      frequency: const Duration(days: 1),
      constraints: Constraints(networkType: NetworkType.notRequired),
    );
  }

  static void registerPruneRemovedNovels() {
    Workmanager().registerPeriodicTask(
      WorkerConstants.idPruneRemovedNovels,
      WorkerConstants.taskPruneRemovedNovels,
      frequency: const Duration(hours: 12),
      constraints: Constraints(networkType: NetworkType.notRequired),
    );
  }
}
