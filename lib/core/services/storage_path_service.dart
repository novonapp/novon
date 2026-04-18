import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../common/constants/app_constants.dart';

/// Centralized authority for filesystem-based persistent storage management
/// and directory resolution.
///
/// Orchestrates the canonical storage root, ensures directory structural
/// integrity, and provides telemetry regarding localized resource utilization.
class StoragePathService {
  StoragePathService._();
  static final StoragePathService instance = StoragePathService._();

  String? _resolvedPath;
  bool _isOnboardingComplete = false;

  /// Orchestrates the appraisal of localized storage configurations and
  /// performs environmental resolution for persistent anchors.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AppConstants.prefStoragePath);
    if (saved != null && saved.isNotEmpty) {
      _resolvedPath = saved;
    }
    _isOnboardingComplete =
        prefs.getBool(AppConstants.prefOnboardingComplete) ?? false;

    // If we already have a valid storage path, onboarding is effectively complete.
    // This avoids accidentally showing onboarding again after app restarts.
    if (_resolvedPath != null) {
      _isOnboardingComplete = true;
    }
  }

  /// Returns the canonical storage root if environmental resolution was successful.
  String? get storagePath => _resolvedPath;

  /// Appraises whether the storage environment has been initialized.
  bool get isConfigured => _resolvedPath != null;

  /// Appraises whether the initial setup workflow has reached completion.
  bool get isOnboardingComplete => _isOnboardingComplete;

  Future<void> setOnboardingComplete() async {
    _isOnboardingComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefOnboardingComplete, true);
  }

  Future<void> setStoragePath(String path) async {
    _resolvedPath = path;
    _isOnboardingComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefStoragePath, path);
    await prefs.setBool(AppConstants.prefOnboardingComplete, true);
  }

  Future<void> clearStoragePath() async {
    _resolvedPath = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefStoragePath);
  }

  Future<void> resetOnboarding() async {
    _isOnboardingComplete = false;
    _resolvedPath = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefOnboardingComplete, false);
    await prefs.remove(AppConstants.prefStoragePath);
  }

  String get databaseDir => p.join(_resolvedPath!, AppConstants.dirDatabase);
  String get hiveDir => p.join(_resolvedPath!, AppConstants.dirSettings);
  String get backupsDir => p.join(_resolvedPath!, AppConstants.dirBackups);
  String get downloadsDir => p.join(_resolvedPath!, AppConstants.dirDownloads);
  String get coversDir => p.join(_resolvedPath!, AppConstants.dirCovers);
  String get cacheDir => p.join(_resolvedPath!, AppConstants.dirCache);

  /// Orchestrates the creation of the standardized directory hierarchy
  /// required for application operation.
  Future<void> ensureDirectoriesExist() async {
    final dirs = [
      databaseDir,
      hiveDir,
      backupsDir,
      downloadsDir,
      coversDir,
      cacheDir,
    ];
    for (final dir in dirs) {
      await Directory(dir).create(recursive: true);
    }
  }

  Future<int> calculateTotalSize() async {
    final root = Directory(_resolvedPath!);
    if (!await root.exists()) return 0;
    int total = 0;
    await for (final entity in root.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        try {
          total += await entity.length();
        } catch (_) {}
      }
    }
    return total;
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  Future<int> calculateDirSize(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) return 0;
    int total = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        try {
          total += await entity.length();
        } catch (_) {}
      }
    }
    return total;
  }

  /// Resolves the fallback storage anchor provided by the localized platform environment.
  Future<String> getFallbackPath() async {
    final dir = await getApplicationSupportDirectory();
    return p.join(dir.path, AppConstants.appName);
  }

  Future<void> placeNomediaFile(String dirPath) async {
    try {
      final nomedia = File('$dirPath/.nomedia');
      if (!await nomedia.exists()) {
        await nomedia.create(recursive: true);
      }
    } catch (_) {}
  }
}
