import 'dart:developer' as developer;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:novon/core/common/enums/novel_refresh_results.dart';
import 'package:path/path.dart' as p;
import 'package:hive_flutter/hive_flutter.dart';

import '../data/repositories/novel_repository.dart';
import '../data/repositories/chapter_repository.dart';
import '../common/models/chapter.dart' as m;
import '../common/models/novel.dart';
import '../services/storage_path_service.dart';
import '../services/exception_logger_service.dart';
import '../common/constants/hive_constants.dart';
import '../data/network/dio_factory.dart';

/// Specialized orchestration service for managing the synchronization of novel
/// metadata and chapter indices between remote repositories and localized persistence.
///
/// Implements differential patching to ensure remote updates do not overwrite
/// user-specific attributes such as read status and localized assets.
class NovelMetadataService {
  NovelMetadataService._();
  static final NovelMetadataService instance = NovelMetadataService._();

  /// Orchestrates the synchronization of novel metadata and chapter indices
  /// for library items, employing a differential patching strategy to
  /// preserve localized state.
  Future<NovelRefreshResult> refreshIfInLibrary({
    required String novelUrl,
    required NovelRepository novelRepo,
    required ChapterRepository chapterRepo,
    required Map<String, dynamic> freshDetail,
    required List<dynamic> freshChapters,
  }) async {
    try {
      final cached = await novelRepo.getNovelById(novelUrl);
      if (cached == null || !cached.inLibrary) {
        return NovelRefreshResult.nothingChanged;
      }

      final sps = StoragePathService.instance;

      var result = NovelRefreshResult.nothingChanged;

      // Appraises and applies structural metadata updates while isolating
      // user-specific attributes from modification.
      if (freshDetail.isNotEmpty) {
        try {
          String? patchTitle;
          String? patchAuthor;
          String? patchDescription;
          String? patchCoverUrl;
          String? patchStatus;
          List<String>? patchGenres;

          final remoteTitle = (freshDetail['title'] ?? '').toString().trim();
          if (remoteTitle.isNotEmpty && remoteTitle != cached.title) {
            patchTitle = remoteTitle;
          }

          final remoteAuthor = (freshDetail['author'] ?? '').toString().trim();
          if (remoteAuthor.isNotEmpty && remoteAuthor != cached.author) {
            patchAuthor = remoteAuthor;
          }

          final remoteDesc = (freshDetail['description'] ?? '')
              .toString()
              .trim();
          if (remoteDesc.isNotEmpty && remoteDesc != cached.description) {
            patchDescription = remoteDesc;
          }

          final remoteStatus = (freshDetail['status'] ?? '').toString().trim();
          if (remoteStatus.isNotEmpty && remoteStatus != cached.status.name) {
            patchStatus = remoteStatus;
          }

          final rawGenres = freshDetail['genres'];
          if (rawGenres is List) {
            final remoteGenres = rawGenres.map((e) => e.toString()).toList();
            if (remoteGenres.isNotEmpty &&
                remoteGenres.join(',') != cached.genres.join(',')) {
              patchGenres = remoteGenres;
            }
          }

          // Cover: download if URL changed, keep local otherwise.
          final remoteCoverUrl = (freshDetail['coverUrl'] ?? '')
              .toString()
              .trim();
          if (remoteCoverUrl.isNotEmpty && sps.isConfigured) {
            final isAlreadyLocal = cached.coverUrl.startsWith('/');
            final urlChanged =
                !isAlreadyLocal && remoteCoverUrl != cached.coverUrl;
            if (urlChanged) {
              final localPath = await _downloadCoverLocally(
                remoteCoverUrl,
                novelUrl,
                sps.coversDir,
              );
              if (localPath != null) {
                if (isAlreadyLocal) {
                  try {
                    File(cached.coverUrl).deleteSync();
                  } catch (_) {}
                }
                patchCoverUrl = localPath;
              }
            }
          }

          if (patchTitle != null ||
              patchAuthor != null ||
              patchDescription != null ||
              patchCoverUrl != null ||
              patchStatus != null ||
              patchGenres != null) {
            await novelRepo.patchNovelMetadata(
              novelUrl,
              title: patchTitle,
              author: patchAuthor,
              description: patchDescription,
              coverUrl: patchCoverUrl,
              status: patchStatus,
              genres: patchGenres,
              lastFetched: DateTime.now(),
            );
            result = NovelRefreshResult.metadataUpdated;
          }
        } catch (e, st) {
          developer.log(
            '[NovelMetadataService] detail diff error for $novelUrl: $e',
          );
          ExceptionLoggerService.instance.log(e, st);
        }
      }

      // Appraises the remote chapter index and orchestrates the insertion of
      // new entities without impacting localized read or download states.
      if (freshChapters.isNotEmpty) {
        try {
          final existing = await chapterRepo.getChaptersForNovel(novelUrl);
          final existingIds = existing.map((c) => c.id).toSet();

          final toUpsert = <m.Chapter>[];
          int newCount = 0;

          for (final item in freshChapters) {
            final map = Map<String, dynamic>.from(item as Map);
            final url = (map['url'] ?? '').toString().trim();
            final name = (map['name'] ?? '').toString().trim();
            if (url.isEmpty || name.isEmpty) continue;

            final chapterId = url;
            final number = (map['number'] is num)
                ? (map['number'] as num).toDouble()
                : -1.0;
            if (!existingIds.contains(chapterId)) newCount++;

            toUpsert.add(
              m.Chapter(
                id: chapterId,
                novelId: novelUrl,
                url: url,
                name: name,
                number: number,
              ),
            );
          }

          if (toUpsert.isNotEmpty) {
            await chapterRepo.upsertChapters(toUpsert);
            if (newCount > 0) {
              result = NovelRefreshResult.newChapters;
              await novelRepo.patchNovelMetadata(
                novelUrl,
                lastFetched: DateTime.now(),
              );
            }
          }
        } catch (e, st) {
          developer.log(
            '[NovelMetadataService] chapter diff error for $novelUrl: $e',
          );
          ExceptionLoggerService.instance.log(e, st);
        }
      }

      return result;
    } catch (e, st) {
      ExceptionLoggerService.instance.log(e, st);
      return NovelRefreshResult.nothingChanged;
    }
  }

  /// Initializes localized caching for a library novel, orchestrating the
  /// acquisition of remote assets for offline availability.
  Future<void> initializeLocalCache({
    required Novel novel,
    required NovelRepository novelRepo,
  }) async {
    try {
      final sps = StoragePathService.instance;
      if (!sps.isConfigured) return;
      if (novel.coverUrl.isEmpty || novel.coverUrl.startsWith('/')) return;

      final localPath = await _downloadCoverLocally(
        novel.coverUrl,
        novel.id,
        sps.coversDir,
      );
      await sps.placeNomediaFile(sps.coversDir);

      if (localPath != null) {
        await novelRepo.patchNovelMetadata(novel.id, coverUrl: localPath);
      }
    } catch (e, st) {
      ExceptionLoggerService.instance.log(e, st);
    }
  }

  /// Orchestrates the scheduling of diagnostic data cleanup for decommissioned
  /// library entities after a defined grace period.
  static void scheduleGracePeriodCleanup(String novelId) {
    try {
      final box = Hive.box(HiveBox.removedNovels);
      final raw = box.get(HiveKeys.removedNovelsIndex);
      final index = (raw is Map)
          ? Map<String, dynamic>.from(raw)
          : <String, dynamic>{};
      index[novelId] = DateTime.now().toIso8601String();
      box.put(HiveKeys.removedNovelsIndex, index);
    } catch (e) {
      developer.log(
        '[NovelMetadataService] scheduleGracePeriodCleanup error: $e',
      );
    }
  }

  /// Cancel a scheduled cleanup (e.g. novel re-added to library).
  static void cancelGracePeriodCleanup(String novelId) {
    try {
      final box = Hive.box(HiveBox.removedNovels);
      final raw = box.get(HiveKeys.removedNovelsIndex);
      if (raw is Map) {
        final index = Map<String, dynamic>.from(raw);
        index.remove(novelId);
        box.put(HiveKeys.removedNovelsIndex, index);
      }
    } catch (e) {
      developer.log(
        '[NovelMetadataService] cancelGracePeriodCleanup error: $e',
      );
    }
  }

  /// Returns novelIds whose 3-day grace period has expired.
  static List<String> getExpiredRemovedNovels({int graceDays = 3}) {
    try {
      final box = Hive.box(HiveBox.removedNovels);
      final raw = box.get(HiveKeys.removedNovelsIndex);
      if (raw is! Map) return const [];
      final index = Map<String, dynamic>.from(raw);
      final cutoff = DateTime.now().subtract(Duration(days: graceDays));
      return index.entries
          .where((e) {
            final ts = DateTime.tryParse(e.value?.toString() ?? '');
            return ts != null && ts.isBefore(cutoff);
          })
          .map((e) => e.key)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// Remove expired entries from the grace period index after cleanup.
  static void clearExpiredFromIndex(List<String> novelIds) {
    try {
      final box = Hive.box(HiveBox.removedNovels);
      final raw = box.get(HiveKeys.removedNovelsIndex);
      if (raw is Map) {
        final index = Map<String, dynamic>.from(raw);
        for (final id in novelIds) {
          index.remove(id);
        }
        box.put(HiveKeys.removedNovelsIndex, index);
      }
    } catch (_) {}
  }

  /// Facilitates the acquisition and localized persistence of remote cover assets.
  Future<String?> _downloadCoverLocally(
    String remoteUrl,
    String novelId,
    String coversDir,
  ) async {
    try {
      await Directory(coversDir).create(recursive: true);
      final safeId = Uri.encodeComponent(novelId).replaceAll('%', '_');
      final ext = _guessExtension(remoteUrl);
      final localFile = File(p.join(coversDir, '$safeId$ext'));
      await StoragePathService.instance.placeNomediaFile(coversDir);

      final dio = DioFactory.create(
        receiveTimeout: const Duration(seconds: 30),
      );
      final response = await dio.get<List<int>>(
        remoteUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        await localFile.writeAsBytes(response.data!);
        return localFile.path;
      }
    } catch (e) {
      developer.log('[NovelMetadataService] cover download failed: $e');
    }
    return null;
  }

  String _guessExtension(String url) {
    final path = Uri.tryParse(url)?.path ?? '';
    if (path.endsWith('.webp')) return '.webp';
    if (path.endsWith('.png')) return '.png';
    if (path.endsWith('.gif')) return '.gif';
    return '.jpg';
  }
}
