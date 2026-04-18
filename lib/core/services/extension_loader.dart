import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:archive/archive.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/config/app_config.dart';
import '../common/models/extension_manifest.dart';
import '../common/models/repo_index.dart';
import '../data/network/dio_factory.dart';
import 'storage_path_service.dart';
import 'extension_engine.dart';
import '../common/constants/hive_constants.dart';
import '../common/constants/app_constants.dart';

/// Centralized orchestration layer for the lifecycle management of modular extensions,
/// facilitating secure acquisition, compatibility appraisal, and persistent storage.
class ExtensionLoader {
  static ExtensionLoader? _instance;
  static ExtensionLoader get instance => _instance ??= ExtensionLoader._();

  ExtensionLoader._();

  final Dio _dio = DioFactory.create();
  final Box _extBox = Hive.box(HiveBox.extensions);

  Future<String> _getExtensionsDir() async {
    final sps = StoragePathService.instance;
    final base = sps.isConfigured
        ? sps.storagePath!
        : await sps.getFallbackPath();
    return '$base/extensions';
  }

  /// Appraises the localized extension repository and identifies all compatible
  /// extension manifests.
  Future<List<ExtensionManifest>> discoverAll() async {
    final extDir = await _getExtensionsDir();
    final dir = Directory(extDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      return [];
    }

    final manifests = <ExtensionManifest>[];
    await for (final entity in dir.list()) {
      if (entity is Directory) {
        try {
          final manifest = await _loadManifest(entity.path);
          if (manifest != null && await _isCompatible(manifest)) {
            manifests.add(manifest);
          }
        } catch (_) {}
      }
    }
    return manifests;
  }

  Future<ExtensionManifest?> _loadManifest(String extDirPath) async {
    final manifestFile = File('$extDirPath/${AppConstants.filenameManifest}');
    if (!await manifestFile.exists()) return null;

    final content = await manifestFile.readAsString();
    final json = jsonDecode(content) as Map<String, dynamic>;
    return ExtensionManifest.fromJson(json);
  }

  /// Evaluates the compatibility of an extension manifest against the
  /// current application version and API surface.
  Future<bool> _isCompatible(ExtensionManifest manifest) async {
    try {
      final manifestApi = int.tryParse(manifest.apiVersion) ?? 0;
      final currentApi = AppConfig.apiVersion;
      if (manifestApi > currentApi) return false;

      final packageInfo = await PackageInfo.fromPlatform();
      final minAppVer = Version.parse(manifest.minAppVersion);
      final currentVer = Version.parse(packageInfo.version);

      if (currentVer < minAppVer) return false;

      if (manifest.maxAppVersion != null) {
        final maxAppVer = Version.parse(manifest.maxAppVersion!);
        if (currentVer > maxAppVer) return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> verifyIntegrity(String extensionId) async {
    final extensionsDir = await _getExtensionsDir();
    final extDir = '$extensionsDir/$extensionId';
    final manifestFile = File('$extDir/${AppConstants.filenameManifest}');
    final sourceFile = File('$extDir/${AppConstants.filenameSource}');

    if (!await manifestFile.exists() || !await sourceFile.exists()) {
      return false;
    }
    return true;
  }

  /// Resolves the JavaScript source code for a specific extension from the
  /// localized asset repository.
  Future<String?> loadScriptSource(String extensionId) async {
    final extensionsDir = await _getExtensionsDir();
    final sourceFile = File(
      '$extensionsDir/$extensionId/${AppConstants.filenameSource}',
    );
    if (await sourceFile.exists()) {
      return await sourceFile.readAsString();
    }
    return null;
  }

  /// Orchestrates the retrieval and localized caching of an external
  /// extension repository index.
  Future<RepoIndex?> fetchRepoIndex(String repoUrl) async {
    try {
      final response = await _dio.get(repoUrl);
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> json;
        if (response.data is String) {
          json = jsonDecode(response.data);
        } else {
          json = response.data;
        }
        final index = RepoIndex.fromJson(json);

        final urlHash = sha256
            .convert(utf8.encode(repoUrl))
            .toString()
            .substring(0, 16);
        await _extBox.put(
          '${HiveKeys.extRepoIndexPrefix}$urlHash',
          jsonEncode(json),
        );

        return index;
      }
    } catch (_) {
      final urlHash = sha256
          .convert(utf8.encode(repoUrl))
          .toString()
          .substring(0, 16);
      final cached = _extBox.get('${HiveKeys.extRepoIndexPrefix}$urlHash');
      if (cached is String) {
        try {
          return RepoIndex.fromJson(jsonDecode(cached));
        } catch (_) {}
      }
    }
    return null;
  }

  /// Facilitates the acquisition and installation of an extension from a
  /// remote repository, including archive extraction and integrity verification.
  Future<ExtensionManifest> installFromRepo(RepoExtensionEntry entry) async {
    Response<List<int>> response;
    try {
      response = await _dio.get<List<int>>(
        entry.downloadUrl,
        options: Options(responseType: ResponseType.bytes),
      );
    } on DioException catch (e) {
      throw Exception('Network error downloading bundle: ${e.message}');
    }

    if (response.data == null) {
      throw Exception('Failed to download extension bundle');
    }

    final bytes = response.data!;
    final computedHash = sha256.convert(bytes).toString().toLowerCase();
    final expectedHash = entry.sha256.toLowerCase();

    if (computedHash != expectedHash) {
      throw Exception('Download corrupted: SHA-256 mismatch');
    }

    final archive = ZipDecoder().decodeBytes(bytes);
    final extensionsDir = await _getExtensionsDir();
    final extDir = '$extensionsDir/${entry.id}';
    await StoragePathService.instance.placeNomediaFile(extensionsDir);

    await Directory(extDir).create(recursive: true);

    for (final file in archive) {
      final filePath = '$extDir/${file.name}';
      if (file.isFile) {
        final outFile = File(filePath);
        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      } else {
        await Directory(filePath).create(recursive: true);
      }
    }

    await Directory('$extDir/tmp').create(recursive: true);

    final manifest = await _loadManifest(extDir);
    if (manifest == null) {
      await Directory(extDir).delete(recursive: true);
      throw Exception('Invalid manifest in downloaded bundle');
    }

    await _extBox.put('${HiveKeys.extTrustedPrefix}${entry.id}', true);
    await _extBox.put('${HiveKeys.extEnabledPrefix}${entry.id}', true);

    return manifest;
  }

  Future<ExtensionManifest> installFromUrl(String url) async {
    Response response;
    try {
      response = await _dio.get(url);
    } on DioException catch (e) {
      throw Exception('Network error fetching extension: ${e.message}');
    }

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('Failed to fetch extension: HTTP ${response.statusCode}');
    }

    final Map<String, dynamic> json;
    if (response.data is String) {
      json = jsonDecode(response.data);
    } else {
      json = response.data;
    }

    if (json.containsKey('extensions') && json.containsKey('repoName')) {
      final index = RepoIndex.fromJson(json);
      await addRepo(url);
      if (index.extensions.isEmpty) {
        throw Exception('Repository contains no extensions');
      }
      return installFromRepo(index.extensions.first);
    }

    final manifest = ExtensionManifest.fromJson(json);
    final extensionsDir = await _getExtensionsDir();
    final extDir = '$extensionsDir/${manifest.id}';
    await Directory(extDir).create(recursive: true);
    await File(
      '$extDir/${AppConstants.filenameManifest}',
    ).writeAsString(jsonEncode(json));

    if (manifest.sourceUrl.isNotEmpty) {
      try {
        final sourceResponse = await _dio.get(
          '${manifest.sourceUrl}/source.js',
        );
        if (sourceResponse.statusCode == 200) {
          await File(
            '$extDir/${AppConstants.filenameSource}',
          ).writeAsString(sourceResponse.data.toString());
        }
      } catch (_) {}
    }

    await Directory('$extDir/tmp').create(recursive: true);
    await _extBox.put('${HiveKeys.extTrustedPrefix}${manifest.id}', true);
    await _extBox.put('${HiveKeys.extEnabledPrefix}${manifest.id}', true);

    return manifest;
  }

  Future<void> uninstall(String extensionId) async {
    final extensionsDir = await _getExtensionsDir();
    final extDir = Directory('$extensionsDir/$extensionId');
    if (await extDir.exists()) {
      await extDir.delete(recursive: true);
    }

    ExtensionEngine.instance.disposeExtension(extensionId);
    await _extBox.delete('${HiveKeys.extTrustedPrefix}$extensionId');
    await _extBox.delete('${HiveKeys.extEnabledPrefix}$extensionId');
  }

  /// Evaluates the installed extension base against known repository indices
  /// to identify available versions updates.
  Future<Map<String, RepoExtensionEntry>> checkForUpdates(
    List<ExtensionManifest> installed,
  ) async {
    final updates = <String, RepoExtensionEntry>{};
    final repos = getRepoUrls();

    for (final repoUrl in repos) {
      final index = await fetchRepoIndex(repoUrl);
      if (index == null) continue;

      for (final entry in index.extensions) {
        final match = installed.where((m) => m.id == entry.id).firstOrNull;
        if (match != null) {
          try {
            final installedVer = Version.parse(match.version);
            final repoVer = Version.parse(entry.version);
            if (repoVer > installedVer) {
              updates[entry.id] = entry;
            }
          } catch (_) {}
        }
      }
    }

    return updates;
  }

  List<String> getRepoUrls() {
    final list = _extBox.get(HiveKeys.extRepos);
    if (list is List) return list.cast<String>();
    return [];
  }

  Future<void> addRepo(String url) async {
    final repos = getRepoUrls();
    if (!repos.contains(url)) {
      repos.add(url);
      await _extBox.put(HiveKeys.extRepos, repos);
    }
  }

  Future<void> removeRepo(String url) async {
    final repos = getRepoUrls();
    repos.remove(url);
    await _extBox.put(HiveKeys.extRepos, repos);

    final urlHash = sha256
        .convert(utf8.encode(url))
        .toString()
        .substring(0, 16);
    await _extBox.delete('ext_repo_index_$urlHash');
  }

  bool isTrusted(String extensionId) {
    return _extBox.get(
          '${HiveKeys.extTrustedPrefix}$extensionId',
          defaultValue: false,
        ) ==
        true;
  }

  bool isEnabled(String extensionId) {
    return _extBox.get(
          '${HiveKeys.extEnabledPrefix}$extensionId',
          defaultValue: true,
        ) ==
        true;
  }

  Future<void> setEnabled(String extensionId, bool enabled) async {
    await _extBox.put('${HiveKeys.extEnabledPrefix}$extensionId', enabled);
  }
}
