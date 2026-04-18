import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/models/extension_manifest.dart';
import '../../../core/common/models/repo_index.dart';
import '../../../core/providers/extension_provider.dart';
import '../../../core/theme/novon_colors.dart';

final browseControllerProvider = Provider<BrowseController>((ref) {
  return BrowseController(ref);
});

/// Primary orchestration layer for the lifecycle management of content source
/// extensions, facilitating secure acquisition, uninstallation, and
/// version-based synchronization.
class BrowseController {
  final Ref ref;
  BrowseController(this.ref);

  /// Initiates the asynchronous installation or update sequence for a specific
  /// extension entry from a remote repository.
  Future<void> installOrUpdate(
    BuildContext context,
    RepoExtensionEntry entry,
  ) async {
    try {
      await ref
          .read(installedExtensionsProvider.notifier)
          .installFromRepo(entry);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${entry.name} v${entry.version} installed!'),
            backgroundColor: NovonColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: $e'),
            backgroundColor: NovonColors.error,
          ),
        );
      }
    }
  }

  /// Orchestrates the uninstallation flow, including user confirmation via
  /// UI dialogs and subsequent cleanup of local manifest indices.
  Future<void> confirmUninstall(
    BuildContext context,
    ExtensionManifest manifest,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Uninstall Extension'),
        content: Text(
          'Remove ${manifest.name}? Novels from this source will remain in your library but cannot be updated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: NovonColors.error),
            child: const Text('Uninstall'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref
          .read(installedExtensionsProvider.notifier)
          .uninstall(manifest.id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${manifest.name} uninstalled')));
      }
    }
  }

  /// Performs a component-wise appraisal of semantic versioning strings to
  /// identify available updates by determining precedence between
  /// repository-hosted and localized instances.
  bool isVersionNewer(String installed, String repo) {
    final installedParts = installed
        .split('.')
        .map((s) => int.tryParse(s) ?? 0)
        .toList();
    final repoParts = repo.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    for (var i = 0; i < 3; i++) {
      final ip = i < installedParts.length ? installedParts[i] : 0;
      final rp = i < repoParts.length ? repoParts[i] : 0;
      if (rp > ip) return true;
      if (rp < ip) return false;
    }
    return false;
  }

  /// Appraises the provided extension entries against a search token to
  /// filter for categorical relevance.
  List<RepoExtensionEntry> filterEntries(
    List<RepoExtensionEntry> entries,
    String query,
  ) {
    if (query.isEmpty) return entries;
    final q = query.toLowerCase();
    return entries.where((e) => e.name.toLowerCase().contains(q)).toList();
  }

  /// Orchestrates the categorical segregation of extension entries based on
  /// their localized installation state and version-based archival parity.
  void partitionEntries(
    List<RepoExtensionEntry> filtered,
    Map<String, ExtensionManifest> installedMap, {
    required List<RepoExtensionEntry> updates,
    required List<RepoExtensionEntry> notInstalled,
    required List<RepoExtensionEntry> upToDate,
  }) {
    for (final entry in filtered) {
      final manifest = installedMap[entry.id];
      if (manifest == null) {
        notInstalled.add(entry);
      } else if (isVersionNewer(manifest.version, entry.version)) {
        updates.add(entry);
      } else {
        upToDate.add(entry);
      }
    }
  }
}
