import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../../../core/providers/extension_provider.dart';
import '../../../core/common/models/extension_manifest.dart';
import '../../../core/common/models/repo_index.dart';
import '../widgets/extension_section_header.dart';
import '../widgets/installed_extension_tile.dart';
import '../widgets/available_extension_tile.dart';
import 'package:novon/core/common/constants/router_constants.dart';
import '../controllers/browse_controller.dart';

/// Primary aggregation surface for content source extensions, providing
/// specialized interfaces for catalog discovery, installation management,
/// and version-based update orchestration.
class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Extensions'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'manage_repos') {
                context.push(RouterConstants.pathManageRepos);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'manage_repos',
                child: Text('Manage Repositories'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search extensions...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: NovonColors.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Available'),
                        Consumer(
                          builder: (context, ref, _) {
                            final updateCount = ref
                                .watch(updatableExtensionsProvider)
                                .length;
                            if (updateCount == 0) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: NovonColors.warning,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$updateCount',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Tab(text: 'Installed'),
                ],
                labelColor: NovonColors.primary,
                unselectedLabelColor: NovonColors.textSecondary,
                indicatorColor: NovonColors.primary,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAvailableTab(context), _buildInstalledTab(context)],
      ),
    );
  }

  /// Orchestrates the assembly of the discovery surface, apprising remote
  /// repository indices to identify available and updatable extensions.
  Widget _buildAvailableTab(BuildContext context) {
    final state = ref.watch(availableExtensionsProvider);
    final installedState = ref.watch(installedExtensionsProvider);

    return state.when(
      loading: () => const ExtensionListShimmer(),
      error: (e, st) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: NovonColors.error),
            const SizedBox(height: 16),
            Text('Error: $e', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  ref.read(availableExtensionsProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (entries) {
        final installedMap =
            installedState.whenOrNull(
              data: (list) => {for (var m in list) m.id: m},
            ) ??
            <String, ExtensionManifest>{};

        final filtered = _searchQuery.isEmpty
            ? entries
            : entries
                  .where(
                    (e) => e.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();

        /// Delegated logic for segregating extensions based on installation
        /// state and availability of remote updates.
        final controller = ref.read(browseControllerProvider);
        final updates = <RepoExtensionEntry>[];
        final notInstalled = <RepoExtensionEntry>[];
        final upToDate = <RepoExtensionEntry>[];
        controller.partitionEntries(
          filtered,
          installedMap,
          updates: updates,
          notInstalled: notInstalled,
          upToDate: upToDate,
        );

        if (filtered.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.cloud_download_rounded,
            iconColor: NovonColors.primary,
            title: 'No extensions available',
            subtitle:
                'Add an extension repository using\nthe + button to browse sources',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(availableExtensionsProvider.notifier).refresh();
            await ref.read(installedExtensionsProvider.notifier).refresh();
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            children: [
              if (updates.isNotEmpty) ...[
                ExtensionSectionHeader(
                  icon: Icons.system_update_rounded,
                  title: 'Updates Available',
                  count: updates.length,
                  color: NovonColors.warning,
                ),
                const SizedBox(height: 8),
                ...updates.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AvailableExtensionTile(
                      key: ValueKey('update_${entry.id}'),
                      entry: entry,
                      status: ExtensionTileStatus.update,
                      installedVersion: installedMap[entry.id]?.version,
                      onAction: () => ref
                          .read(browseControllerProvider)
                          .installOrUpdate(context, entry),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (notInstalled.isNotEmpty) ...[
                ExtensionSectionHeader(
                  icon: Icons.add_circle_outline_rounded,
                  title: 'Not Installed',
                  count: notInstalled.length,
                  color: NovonColors.primary,
                ),
                const SizedBox(height: 8),
                ...notInstalled.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AvailableExtensionTile(
                      key: ValueKey('install_${entry.id}'),
                      entry: entry,
                      status: ExtensionTileStatus.install,
                      onAction: () => ref
                          .read(browseControllerProvider)
                          .installOrUpdate(context, entry),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (upToDate.isNotEmpty) ...[
                ExtensionSectionHeader(
                  icon: Icons.check_circle_outline_rounded,
                  title: 'Up to Date',
                  count: upToDate.length,
                  color: NovonColors.success,
                ),
                const SizedBox(height: 8),
                ...upToDate.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AvailableExtensionTile(
                      entry: entry,
                      status: ExtensionTileStatus.installed,
                      onAction: null,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Orchestrates the assembly of the localized installation surface,
  /// providing interfaces for extension management and source navigation.
  Widget _buildInstalledTab(BuildContext context) {
    final state = ref.watch(installedExtensionsProvider);

    return state.when(
      loading: () => const ExtensionListShimmer(),
      error: (e, st) => Center(child: Text('Error loading extensions: $e')),
      data: (extensions) {
        final filtered = _searchQuery.isEmpty
            ? extensions
            : extensions
                  .where(
                    (e) => e.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();

        if (filtered.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.extension_off_rounded,
            iconColor: NovonColors.textTertiary,
            title: 'No extensions installed',
            subtitle:
                'Add an extension repository using\nthe + button to get started',
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(installedExtensionsProvider.notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final manifest = filtered[index];
              return InstalledExtensionTile(
                manifest: manifest,
                onTap: () =>
                    context.push(RouterConstants.sourceBrowse(manifest.id)),
                onUninstall: () => ref
                    .read(browseControllerProvider)
                    .confirmUninstall(context, manifest),
              );
            },
          ),
        );
      },
    );
  }

  /// Specialized UI assembly for terminal states where no categorical extensions
  /// are resolved from the current repository indices or search context.
  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: NovonColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: NovonColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
