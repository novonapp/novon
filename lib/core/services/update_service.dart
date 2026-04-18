import 'dart:convert';
import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novon/core/common/constants/app_constants.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pub_semver/pub_semver.dart';
import '../common/models/app_update_info.dart';
import 'dart:io';

/// Orchestrates the lifecycle of application updates, from discovering
/// new releases via GitHub to managing background downloads and installation.
class UpdateService {
  UpdateService(this.ref);
  final Ref ref;

  /// Queries the standardized GitHub release endpoint and compares the latest
  /// version with the localized application credentials.
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      final dio = Dio();
      final response = await dio.get(AppConstants.linkApi);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final tagName = data['tag_name'] as String;
        final latestVersion = tagName.replaceAll(RegExp(r'[^0-9.]'), '');

        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;

        if (Version.parse(latestVersion) > Version.parse(currentVersion)) {
          final assets = data['assets'] as List;
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
    } catch (e) {
      // Internal logging or silent failure based on context.
    }
    return null;
  }

  /// Initiates a background download task for the provided update asset.
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

  /// Triggers the platform-native package installer for the downloaded update.
  Future<void> installUpdate(String filePath) async {
    final result = await OpenFilex.open(filePath);
    if (result.type != ResultType.done) {
      throw Exception('Failed to open APK: ${result.message}');
    }
  }

  /// Purges any downloaded update assets from the local cache to reclaim storage.
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

final updateServiceProvider = Provider((ref) => UpdateService(ref));

/// Reactive stream providing real-time status updates for the application
/// update download task.
final appUpdateDownloadProvider = StreamProvider.autoDispose<TaskUpdate>((ref) {
  return FileDownloader().updates.where((update) {
    if (update.task.metaData.isNotEmpty) {
      try {
        final meta = jsonDecode(update.task.metaData);
        return meta['type'] == 'app_update';
      } catch (_) {}
    }
    return false;
  });
});
