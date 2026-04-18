import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:novon/core/common/constants/app_constants.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import 'package:novon/core/services/storage_path_service.dart';

/// Specialized orchestration service for managing one-time data migrations and 
/// environmental path reconciliation, facilitating the relocation of 
/// application assets between varied storage anchors.
class MigrationService {
  MigrationService._();

  /// Appraises the current storage configuration and orchestrates the migration 
  /// of legacy fallback data to the user-selected anchoring point.
  static Future<void> maybeMigrateFirstRunData(StoragePathService sps) async {
    final selectedPath = sps.storagePath;
    if (selectedPath == null || selectedPath.isEmpty) return;

    final fallbackPath = await sps.getFallbackPath();
    if (p.equals(p.normalize(fallbackPath), p.normalize(selectedPath))) return;

    final fallbackDir = Directory(fallbackPath);
    if (!await fallbackDir.exists()) return;

    final selectedDatabaseDir =
        Directory(p.join(selectedPath, AppConstants.dirDatabase));
    final selectedHiveDir =
        Directory(p.join(selectedPath, AppConstants.dirSettings));
    final selectedHasDatabase = await selectedDatabaseDir.exists() &&
        selectedDatabaseDir.listSync().isNotEmpty;
    final selectedHasHive =
        await selectedHiveDir.exists() && selectedHiveDir.listSync().isNotEmpty;
    if (selectedHasDatabase || selectedHasHive) return;

    await _copyDirectory(from: Directory(p.join(fallbackPath, AppConstants.dirDatabase)), to: selectedDatabaseDir);
    await _copyHiveRootFiles(fromDir: fallbackDir, toDir: selectedHiveDir);
  }

  static Future<void> _copyHiveRootFiles({
    required Directory fromDir,
    required Directory toDir,
  }) async {
    if (!await fromDir.exists()) return;
    await toDir.create(recursive: true);
    await for (final entity in fromDir.list(followLinks: false)) {
      if (entity is! File) continue;
      final name = p.basename(entity.path);
      final isHiveFile = (name.startsWith('novon_') ||
              name.startsWith(HiveBox.app) ||
              name.startsWith(HiveBox.reader)) &&
          (name.endsWith('.hive') || name.endsWith('.lock'));
      if (!isHiveFile) continue;
      await entity.copy(p.join(toDir.path, name));
    }
  }

  static Future<void> _copyDirectory({
    required Directory from,
    required Directory to,
  }) async {
    if (!await from.exists()) return;
    await to.create(recursive: true);
    await for (final entity in from.list(recursive: true, followLinks: false)) {
      final rel = p.relative(entity.path, from: from.path);
      final target = p.join(to.path, rel);
      if (entity is Directory) {
        await Directory(target).create(recursive: true);
      } else if (entity is File) {
        await File(target).parent.create(recursive: true);
        await entity.copy(target);
      }
    }
  }
}
