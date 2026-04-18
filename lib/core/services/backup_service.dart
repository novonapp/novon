import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../features/statistics/providers/statistics_provider.dart';
import '../data/database/database.dart';
import 'storage_path_service.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(databaseProvider);
  return BackupService(db, StoragePathService.instance);
});

/// Centralized orchestration layer for application state archival and
/// restoration, facilitating compressed serialization of localized
/// persistence and relational data.
class BackupService {
  final AppDatabase db;
  final StoragePathService sps;

  BackupService(this.db, this.sps);

  String get _backupsDir => sps.isConfigured
      ? sps.backupsDir
      : throw StateError(
          'Storage path not configured. Complete onboarding first.',
        );

  /// Orchestrates the creation of a compressed archival snapshot, involving
  /// the serialization of Hive preference boxes and relational database entities.
  Future<String> createBackup() async {
    // Collects application settings while ensuring the exclusion of sensitive security parameters.
    final settingsBox = Hive.box(HiveBox.app);
    final readerBox = Hive.box(HiveBox.reader);

    final settingsMap = settingsBox.toMap().map(
      (k, v) => MapEntry(k.toString(), v),
    );
    const privateKeys = {
      HiveKeys.appLockEnabled,
      HiveKeys.appLockType,
      HiveKeys.appLockPin,
      HiveKeys.appLockTimeout,
    };
    settingsMap.removeWhere((key, _) => privateKeys.contains(key));

    final hiveDump = {
      'settings': settingsMap,
      'reader': readerBox.toMap().map((k, v) => MapEntry(k.toString(), v)),
    };

    // Serializes relational database entities into a portable format.
    final novels = await db.select(db.novels).get();
    final chapters = await db.select(db.chapters).get();
    final history = await db.select(db.history).get();

    final dbDump = {
      'novels': novels.map((e) => e.toJson()).toList(),
      'chapters': chapters.map((e) => e.toJson()).toList(),
      'history': history.map((e) => e.toJson()).toList(),
    };

    // Constructs the final archival payload with environmental metadata.
    final payload = jsonEncode({
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'hive': hiveDump,
      'database': dbDump,
    });

    // Applies GZip compression to the serialized payload for efficient persistence.
    final bytes = utf8.encode(payload);
    final compressed = GZipEncoder().encode(bytes);

    // Persists the compressed archival asset to the localized backup repository.
    final dir = Directory(_backupsDir);
    if (!await dir.exists()) await dir.create(recursive: true);

    final dateToken = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filename = 'novon_backup_$dateToken.json.gz';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(compressed);

    return file.path;
  }

  /// Facilitates the restoration of application state from an external
  /// archival manifest, requiring critical validation and state commitment.
  Future<void> restoreBackup(String path) async {
    final file = File(path);
    if (!await file.exists()) throw Exception('Backup file not found: $path');

    final compressed = await file.readAsBytes();
    final bytes = GZipDecoder().decodeBytes(compressed);
    final payloadStr = utf8.decode(bytes);
    final payload = jsonDecode(payloadStr) as Map<String, dynamic>;

    if (payload['version'] != 1) {
      throw Exception('Unsupported backup version: ${payload['version']}');
    }

    // Restore Hive (preserving local security settings).
    final hiveDump = payload['hive'] as Map<String, dynamic>;
    final settingsBox = Hive.box(HiveBox.app);

    // Save existing security settings before clearing
    const privateKeys = {
      HiveKeys.appLockEnabled,
      HiveKeys.appLockType,
      HiveKeys.appLockPin,
      HiveKeys.appLockTimeout,
    };
    final preservedSettings = <String, dynamic>{};
    for (final key in privateKeys) {
      if (settingsBox.containsKey(key)) {
        preservedSettings[key] = settingsBox.get(key);
      }
    }

    await settingsBox.clear();

    // Apply backup settings
    await settingsBox.putAll(
      (hiveDump['settings'] as Map<String, dynamic>).cast<String, dynamic>(),
    );

    // Restore preserved security settings
    if (preservedSettings.isNotEmpty) {
      await settingsBox.putAll(preservedSettings);
    }

    final readerBox = Hive.box(HiveBox.reader);
    await readerBox.clear();
    await readerBox.putAll(
      (hiveDump['reader'] as Map<String, dynamic>).cast<String, dynamic>(),
    );

    // Restore SQLite.
    final dbDump = payload['database'] as Map<String, dynamic>;
    await db.transaction(() async {
      await db.delete(db.history).go();
      await db.delete(db.chapters).go();
      await db.delete(db.novels).go();

      for (final n in dbDump['novels'] as List) {
        await db
            .into(db.novels)
            .insert(Novel.fromJson(n as Map<String, dynamic>));
      }
      for (final c in dbDump['chapters'] as List) {
        await db
            .into(db.chapters)
            .insert(Chapter.fromJson(c as Map<String, dynamic>));
      }
      for (final h in dbDump['history'] as List) {
        await db
            .into(db.history)
            .insert(HistoryData.fromJson(h as Map<String, dynamic>));
      }
    });
  }

  Future<List<FileSystemEntity>> listBackups() async {
    final dir = Directory(_backupsDir);
    if (!await dir.exists()) return [];
    final files = await dir
        .list()
        .where((e) => e is File && e.path.endsWith('.json.gz'))
        .toList();
    files.sort((a, b) => b.path.compareTo(a.path)); // newest first
    return files;
  }

  Future<void> pruneOldBackups(int keepCount) async {
    final files = await listBackups();
    if (files.length <= keepCount) return;
    for (final f in files.skip(keepCount)) {
      try {
        await f.delete();
      } catch (_) {}
    }
  }
}
