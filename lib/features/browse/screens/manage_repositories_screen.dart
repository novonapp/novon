import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/extension_provider.dart';
import '../../../core/theme/novon_colors.dart';

/// Orchestration interface for managing remote extension repositories, facilitating
/// the registration and decommissioning of third-party index sources.
class ManageRepositoriesScreen extends ConsumerStatefulWidget {
  const ManageRepositoriesScreen({super.key});

  @override
  ConsumerState<ManageRepositoriesScreen> createState() =>
      _ManageRepositoriesScreenState();
}

class _ManageRepositoriesScreenState
    extends ConsumerState<ManageRepositoriesScreen> {
  late List<String> _repos;

  @override
  void initState() {
    super.initState();
    _repos = ref.read(extensionLoaderProvider).getRepoUrls();
  }

  void _reload() {
    setState(() => _repos = ref.read(extensionLoaderProvider).getRepoUrls());
  }

  /// Orchestrates the asynchronous registration of a new repository anchor,
  /// encompassing user-driven data entry and subsequently triggering
  /// an index synchronization.
  Future<void> _addRepo() async {
    final controller = TextEditingController();
    final url = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add repository'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'https://.../index.json'),
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (url == null || url.isEmpty) return;
    await ref.read(extensionLoaderProvider).addRepo(url);
    _reload();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Repository added'),
          backgroundColor: NovonColors.success,
        ),
      );
    }
    // refresh available extensions list
    await ref.read(availableExtensionsProvider.notifier).refresh();
  }

  /// Orchestrates the decommissioning of a registered repository from localized
  /// configuration and refreshes the available extension manifest index.
  Future<void> _removeRepo(String url) async {
    await ref.read(extensionLoaderProvider).removeRepo(url);
    _reload();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Removed repo: $url')));
    }
    await ref.read(availableExtensionsProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage repositories'),
        actions: [
          IconButton(
            tooltip: 'Add',
            icon: const Icon(Icons.add_rounded),
            onPressed: _addRepo,
          ),
        ],
      ),
      body: _repos.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.hub_rounded,
                      size: 48,
                      color: NovonColors.textTertiary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No repositories added',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a repository URL to browse and install extensions.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: NovonColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _addRepo,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add repository'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _repos.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final url = _repos[index];
                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: NovonColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: NovonColors.divider),
                  ),
                  child: ListTile(
                    title: Text(
                      url,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: NovonColors.error,
                      ),
                      onPressed: () => _removeRepo(url),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
