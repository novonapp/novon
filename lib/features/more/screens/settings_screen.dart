import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novon/core/common/constants/router_constants.dart';

/// High-level configuration gateway orchestrating application-wide 
/// preferences into categorical navigational branches.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _settingTile(context, Icons.palette_rounded, 'Appearance', 'Theme, language, display modes', RouterConstants.moreAppearance),
          _settingTile(context, Icons.menu_book_rounded, 'Reader', 'Reading mode, font, margins', RouterConstants.moreReader),
          _settingTile(context, Icons.download_rounded, 'Downloads', 'Location, retry, network', RouterConstants.moreDownloads),
          _settingTile(context, Icons.sync_rounded, 'Tracking', 'AniList, MyAnimeList, NovelUpdates', RouterConstants.moreTracking),
          _settingTile(context, Icons.explore_rounded, 'Browse', 'Languages, repositories, search', RouterConstants.moreBrowseSettings),
          _settingTile(context, Icons.public_rounded, 'Network & User-Agent', 'Proxy, DoH, Cloudflare', RouterConstants.moreNetwork),
          _settingTile(context, Icons.notifications_rounded, 'Notifications', 'Updates, alerts', RouterConstants.moreNotifications),
          _settingTile(context, Icons.security_rounded, 'Security & Privacy', 'App lock, incognito, permissions', RouterConstants.moreSecurity),
          _settingTile(context, Icons.developer_mode_rounded, 'Advanced', 'Developer mode, logs', RouterConstants.moreAdvanced),
          _settingTile(context, Icons.storage_rounded, 'Data & Storage', 'Location, backup, restore', RouterConstants.moreData),
        ],
      ),
    );
  }

  /// Orchestrates the assembly of a standardized navigational tile for 
  /// specific configuration categories.
  Widget _settingTile(BuildContext context, IconData icon, String title, String subtitle, String route) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 24),
      title: Text(title),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      trailing: Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), size: 18),
      onTap: () => context.go(route),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
