import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/novon_colors.dart';
import 'package:novon/core/common/constants/router_constants.dart';
import '../../../core/common/widgets/branding_logo.dart';
import '../widgets/version_text.dart';

/// Centralized navigational surface orchestrating access to non-content
/// utility features, administrative configurations, and application metadata.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(floating: true, title: Text('More')),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E0F11),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E0F11),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(child: BrandingLogo(size: 48)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Novon',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            const VersionText(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                _menuItem(
                  context,
                  icon: Icons.download_rounded,
                  title: 'Downloads',
                  subtitle: 'Manage downloaded chapters',
                  onTap: () => context.go(RouterConstants.moreDownloads),
                ),
                _menuItem(
                  context,
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  subtitle: 'App configuration',
                  onTap: () => context.go(RouterConstants.moreSettings),
                ),
                _menuItem(
                  context,
                  icon: Icons.backup_rounded,
                  title: 'Backup & Restore',
                  subtitle: 'Export or import your library',
                  onTap: () => context.go(RouterConstants.moreBackup),
                ),
                _menuItem(
                  context,
                  icon: Icons.bar_chart_rounded,
                  title: 'Statistics',
                  subtitle: 'Reading time and charts',
                  onTap: () => context.go(RouterConstants.moreStatistics),
                ),
                _menuItem(
                  context,
                  icon: Icons.sync_rounded,
                  title: 'Tracking',
                  subtitle: 'AniList, MAL, NovelUpdates',
                  onTap: () => context.go(RouterConstants.moreTracking),
                ),
                const Divider(indent: 16, endIndent: 16),
                _menuItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  subtitle: 'Version, licenses, links',
                  onTap: () => context.go(RouterConstants.moreAbout),
                ),
                _menuItem(
                  context,
                  icon: Icons.bug_report_outlined,
                  title: 'Report Issue',
                  subtitle: 'Help improve Novon',
                  onTap: () => context.go(RouterConstants.moreReport),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// High-order component for rendering a standardized navigational entry point
  /// within the utility directory.
  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: NovonColors.textTertiary,
        size: 20,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

