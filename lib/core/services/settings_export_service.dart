import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'storage_path_service.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

final settingsExportServiceProvider = Provider<SettingsExportService>((ref) {
  return SettingsExportService(StoragePathService.instance);
});

const int _kSettingsVersion = 1;

/// Specialized orchestration service for the serialization and restoration of
/// application-level preferences, facilitating portable configuration management.
class SettingsExportService {
  final StoragePathService sps;

  SettingsExportService(this.sps);

  String get _exportFilePath {
    if (!sps.isConfigured) {
      throw StateError(
        'Storage path not configured. Complete onboarding first.',
      );
    }
    return '${sps.storagePath!}/novon_settings.json';
  }

  /// Orchestrates the serialization of application and reader preferences into
  /// a portable JSON manifest, ensuring the exclusion of sensitive metadata.
  Future<String> exportSettings() async {
    final settingsBox = Hive.box(HiveBox.app);
    final readerBox = Hive.box(HiveBox.reader);

    // Filters sensitive security parameters to ensure archival integrity.
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

    final payload = {
      'version': _kSettingsVersion,
      'exported_at': DateTime.now().toIso8601String(),
      'settings': settingsMap,
      'reader': readerBox.toMap().map((k, v) => MapEntry(k.toString(), v)),
    };

    final jsonStr = const JsonEncoder.withIndent('  ').convert(payload);
    final file = File(_exportFilePath);
    await file.writeAsString(jsonStr, flush: true);
    return file.path;
  }

  /// Facilitates the restoration of application preferences from an external
  /// manifest, performing version validation and selective attribute merging.
  Future<void> importSettings(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw Exception('Settings file not found: $path');
    }

    final jsonStr = await file.readAsString();
    final payload = jsonDecode(jsonStr) as Map<String, dynamic>;

    final version = payload['version'];
    if (version == null || version is! int) {
      throw Exception('Invalid settings file: missing version field.');
    }
    if (version > _kSettingsVersion) {
      throw Exception(
        'This settings file was exported from a newer version of Novon '
        '(version $version). Please update the app to import it.',
      );
    }

    final settingsBox = Hive.box(HiveBox.app);
    final readerBox = Hive.box(HiveBox.reader);

    final settingsData = payload['settings'] as Map<String, dynamic>?;
    final readerData = payload['reader'] as Map<String, dynamic>?;

    if (settingsData != null) {
      // Orchestrates a safe merge of settings, preserving critical environmental
      // anchors and localized security parameters.
      final safeSettings = Map<String, dynamic>.from(settingsData)
        ..remove(HiveKeys.storageUri)
        ..remove(HiveKeys.onboardingComplete)
        ..remove(HiveKeys.appLockEnabled)
        ..remove(HiveKeys.appLockType)
        ..remove(HiveKeys.appLockPin)
        ..remove(HiveKeys.appLockTimeout);

      await settingsBox.putAll(safeSettings);
    }

    if (readerData != null) {
      await readerBox.putAll(readerData);
    }
  }

  Future<bool> exportFileExists() async {
    if (!sps.isConfigured) return false;
    return File(_exportFilePath).exists();
  }

  Future<DateTime?> lastExportTime() async {
    if (!sps.isConfigured) return null;
    final file = File(_exportFilePath);
    if (!await file.exists()) return null;
    return file.lastModified();
  }
}
