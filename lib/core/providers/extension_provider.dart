import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/models/extension_manifest.dart';
import '../common/models/repo_index.dart';
import '../services/extension_loader.dart';
import '../services/extension_engine.dart';

final extensionLoaderProvider = Provider<ExtensionLoader>((ref) {
  return ExtensionLoader.instance;
});

final installedExtensionsProvider =
    StateNotifierProvider<
      InstalledExtensionsNotifier,
      AsyncValue<List<ExtensionManifest>>
    >((ref) {
      final loader = ref.watch(extensionLoaderProvider);
      return InstalledExtensionsNotifier(loader);
    });

final availableExtensionsProvider =
    StateNotifierProvider<
      AvailableExtensionsNotifier,
      AsyncValue<List<RepoExtensionEntry>>
    >((ref) {
      final loader = ref.watch(extensionLoaderProvider);
      return AvailableExtensionsNotifier(loader);
    });

/// Computes a list of repo entries that have a newer version than the installed one.
final updatableExtensionsProvider = Provider<List<RepoExtensionEntry>>((ref) {
  final available = ref.watch(availableExtensionsProvider);
  final installed = ref.watch(installedExtensionsProvider);

  return available.whenOrNull(
        data: (entries) {
          final installedMap =
              installed.whenOrNull(
                data: (list) => {for (var m in list) m.id: m},
              ) ??
              <String, ExtensionManifest>{};

          return entries.where((e) {
            final manifest = installedMap[e.id];
            if (manifest == null) return false;
            return _compareVersions(e.version, manifest.version) > 0;
          }).toList();
        },
      ) ??
      [];
});

/// returns positive if v1 > v2, 0 if equal, negative if v1 < v2.
int _compareVersions(String v1, String v2) {
  final parts1 = v1.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  final parts2 = v2.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  for (var i = 0; i < 3; i++) {
    final p1 = i < parts1.length ? parts1[i] : 0;
    final p2 = i < parts2.length ? parts2[i] : 0;
    if (p1 != p2) return p1.compareTo(p2);
  }
  return 0;
}

class InstalledExtensionsNotifier
    extends StateNotifier<AsyncValue<List<ExtensionManifest>>> {
  final ExtensionLoader _loader;

  InstalledExtensionsNotifier(this._loader)
    : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    try {
      final manifests = await _loader.discoverAll();
      if (mounted) state = AsyncValue.data(manifests);
    } catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }

  Future<void> installFromUrl(String url) async {
    await _loader.installFromUrl(url);
    await refresh();
  }

  Future<void> installFromRepo(RepoExtensionEntry entry) async {
    // Evict the cached runtime so the updated JS is loaded fresh on next use.
    ExtensionEngine.instance.disposeExtension(entry.id);
    await _loader.installFromRepo(entry);
    await refresh();
  }

  Future<void> uninstall(String extensionId) async {
    ExtensionEngine.instance.disposeExtension(extensionId);
    await _loader.uninstall(extensionId);
    await refresh();
  }

  Future<void> toggleEnabled(String extensionId, bool enabled) async {
    await _loader.setEnabled(extensionId, enabled);
    await refresh();
  }
}

class AvailableExtensionsNotifier
    extends StateNotifier<AsyncValue<List<RepoExtensionEntry>>> {
  final ExtensionLoader _loader;

  AvailableExtensionsNotifier(this._loader)
    : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    try {
      final repos = _loader.getRepoUrls();
      final allEntries = <RepoExtensionEntry>[];

      for (final repoUrl in repos) {
        final index = await _loader.fetchRepoIndex(repoUrl);
        if (index != null) {
          allEntries.addAll(index.extensions);
        }
      }

      if (mounted) state = AsyncValue.data(allEntries);
    } catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }
}
