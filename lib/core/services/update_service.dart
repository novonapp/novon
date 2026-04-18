import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novon/core/common/constants/app_constants.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../common/models/app_update_info.dart';

/// Orchestrates the full lifecycle of application updates.
///
/// Responsibilities include discovering new releases via the GitHub Releases
/// API, comparing version identifiers against the currently installed build,
/// initiating background downloads, triggering the platform installer, and
/// cleaning up stale assets from the cache.
///
/// Version format contract:
///   3 segments  ->  major.minor.patch         (build number defaults to 1)
///   4 segments  ->  major.minor.patch.build   (fourth segment is the build)
///
/// Example tag names that are handled correctly:
///   "v0.0.2"    ->  major 0, minor 0, patch 2, build 1
///   "v0.0.2.3"  ->  major 0, minor 0, patch 2, build 3
///   "1.4.0"     ->  major 1, minor 4, patch 0, build 1
class UpdateService {
  UpdateService(this.ref);

  final Ref ref;

  /// Queries the GitHub Releases endpoint defined in [AppConstants.linkApi]
  /// and determines whether a newer version is available.
  ///
  /// The comparison is segment-by-segment across four fields: major, minor,
  /// patch, and build. A tag with only three segments is treated as having
  /// build number 1. The device's current build number is read directly from
  /// [PackageInfo.buildNumber], which maps to the build identifier declared in
  /// pubspec.yaml (the integer after the `+` symbol).
  ///
  /// Returns an [AppUpdateInfo] describing the release when an update exists
  /// and the release contains an `.apk` asset. Returns `null` when the
  /// installed version is current, when no APK asset is attached to the
  /// release, or when any network or parsing error occurs.
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      final dio = Dio();
      final response = await dio.get(AppConstants.linkApi);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Raw tag name from the GitHub release, e.g. "v0.0.2.3".
        final tagName = data['tag_name'] as String;

        // Strip any non-numeric, non-dot characters so "v0.0.2.3" -> "0.0.2.3".
        final latestVersion = tagName.replaceAll(RegExp(r'[^0-9.]'), '');

        final packageInfo = await PackageInfo.fromPlatform();

        // The version string as declared in pubspec.yaml before the `+`,
        // e.g. "0.0.2".
        final currentVersion = packageInfo.version;

        // The build number as declared after the `+` in pubspec.yaml,
        // e.g. "3". Defaults to 1 when absent or non-numeric.
        final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 1;

        if (_isNewerVersion(latestVersion, currentVersion, currentBuild)) {
          final assets = data['assets'] as List;

          // Locate the first APK asset attached to the release.
          final apkAsset = assets.firstWhere(
            (asset) => (asset['name'] as String).endsWith('.apk'),
            orElse: () => null,
          );

          if (apkAsset != null) {
            return AppUpdateInfo(
              tagName: tagName,
              changelog: data['body'] as String? ?? 'No changelog provided.',
              downloadUrl: apkAsset['browser_download_url'] as String,
              fileName: apkAsset['name'] as String,
              size: apkAsset['size'] as int? ?? 0,
              publishedAt: DateTime.parse(data['published_at'] as String),
            );
          }
        }
      }
    } catch (e, stack) {
      debugPrint('[UpdateService] checkForUpdate failed: $e\n$stack');
    }

    return null;
  }

  /// Returns true when [latestRaw] represents a version strictly greater than
  /// the combination of [currentVersionRaw] and [currentBuild].
  ///
  /// Both version strings may contain three or four dot-separated segments.
  /// Missing segments default to zero, except the build position which
  /// defaults to 1 to match the convention that an unqualified release is
  /// effectively build 1.
  ///
  /// Comparison proceeds left to right and short-circuits at the first
  /// differing segment, consistent with standard precedence rules.
  ///
  /// Parameters:
  ///   [latestRaw]          Version string from the GitHub release tag after
  ///                        stripping non-numeric characters, e.g. "0.0.2.3".
  ///   [currentVersionRaw]  Version portion from [PackageInfo.version],
  ///                        e.g. "0.0.2".
  ///   [currentBuild]       Build number from [PackageInfo.buildNumber] as an
  ///                        integer, e.g. 2.
  bool _isNewerVersion(
    String latestRaw,
    String currentVersionRaw,
    int currentBuild,
  ) {
    // Converts a version string into a list of integers, one per segment.
    List<int> parse(String v) =>
        v.split('.').map((s) => int.tryParse(s) ?? 0).toList();

    final latest = parse(latestRaw);
    final current = parse(currentVersionRaw);

    // Normalize the remote tag into four explicit fields.
    // When the tag has only three segments the build defaults to 1.
    final int lMajor = latest.elementAtOrNull(0) ?? 0;
    final int lMinor = latest.elementAtOrNull(1) ?? 0;
    final int lPatch = latest.elementAtOrNull(2) ?? 0;
    final int lBuild = latest.elementAtOrNull(3) ?? 1;

    // Normalize the installed version. The build comes from PackageInfo
    // directly rather than from the version string, because pubspec.yaml
    // separates them: "0.0.2+3" gives version "0.0.2" and buildNumber "3".
    final int cMajor = current.elementAtOrNull(0) ?? 0;
    final int cMinor = current.elementAtOrNull(1) ?? 0;
    final int cPatch = current.elementAtOrNull(2) ?? 0;
    final int cBuild = currentBuild;

    if (lMajor != cMajor) return lMajor > cMajor;
    if (lMinor != cMinor) return lMinor > cMinor;
    if (lPatch != cPatch) return lPatch > cPatch;
    return lBuild > cBuild;
  }

  /// Enqueues a background download task for the APK described by [updateInfo].
  ///
  /// The task is tagged with metadata so the [appUpdateDownloadProvider] stream
  /// can filter its progress events from unrelated downloads. The download is
  /// written to the system temporary directory and may be paused and resumed.
  Future<void> downloadUpdate(AppUpdateInfo updateInfo) async {
    final task = DownloadTask(
      url: updateInfo.downloadUrl,
      filename: updateInfo.fileName,
      baseDirectory: BaseDirectory.temporary,
      updates: Updates.statusAndProgress,
      allowPause: true,
      metaData: jsonEncode({'type': 'app_update'}),
    );

    await FileDownloader().enqueue(task);
  }

  /// Opens the APK at [filePath] with the platform's native package installer.
  ///
  /// Throws an [Exception] when the installer cannot be opened, for example
  /// when the file is missing or the device blocks sideloaded installs.
  Future<void> installUpdate(String filePath) async {
    final result = await OpenFilex.open(filePath);

    if (result.type != ResultType.done) {
      throw Exception('Failed to open APK installer: ${result.message}');
    }
  }

  /// Deletes the cached APK identified by [fileName] from the temporary
  /// directory, reclaiming storage after installation or cancellation.
  ///
  /// Failures are silently suppressed because cleanup is non-critical and the
  /// OS will evict temporary files on its own schedule.
  Future<void> cleanupUpdate(String fileName) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}

/// Provides a singleton [UpdateService] scoped to the Riverpod container.
final updateServiceProvider = Provider((ref) => UpdateService(ref));

/// Exposes a stream of [TaskUpdate] events for the active app update download.
///
/// Events are filtered by the metadata tag written in [UpdateService.downloadUpdate]
/// so only progress and status changes belonging to the update task reach
/// consumers. The provider disposes itself when no longer observed.
final appUpdateDownloadProvider = StreamProvider.autoDispose<TaskUpdate>((ref) {
  return FileDownloader().updates.where((update) {
    if (update.task.metaData.isEmpty) return false;

    try {
      final meta = jsonDecode(update.task.metaData) as Map<String, dynamic>;
      return meta['type'] == 'app_update';
    } catch (_) {
      return false;
    }
  });
});
