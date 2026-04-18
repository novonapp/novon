import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/novon_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/config/app_config.dart';
import 'package:novon/core/common/constants/router_constants.dart';
import 'package:novon/core/common/constants/app_constants.dart';

import '../../../core/services/update_service.dart';
import '../../../core/common/models/app_update_info.dart';
import '../../../core/common/widgets/branding_logo.dart';

/// Primary informational surface for application metadata,
/// versioning credentials, and navigational access to community
/// resources and legal documentation.
class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  String _version = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  /// Resolves the current application version credentials from the platform-native
  /// manifest and synchronizes the localized UI state.
  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = AppConfig.formatVersion(info.version, info.buildNumber);
    });
  }

  /// Dispatches the provided URI to the platform-native browser or handler
  /// for external content consumption.
  void _launchUrl(String url) async {
    final parsed = Uri.parse(url);
    if (await canLaunchUrl(parsed)) {
      await launchUrl(parsed, mode: LaunchMode.externalApplication);
    }
  }

  /// Orchestrates the appraisal of available updates by querying the internal
  /// update service and navigating to the specialized update interface
  /// if a release is discovered.
  Future<void> _checkForUpdates() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Show a loading indicator for manual check.
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Checking for updates...'),
        duration: Duration(seconds: 1),
      ),
    );

    final updateInfo = await _UpdateCheckHeler.check(ref);

    if (!mounted) return;

    if (updateInfo != null) {
      context.push(RouterConstants.pathAppUpdate, extra: updateInfo);
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('You are on the latest version.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AboutScreenContent(
      version: _version,
      onCheckForUpdates: _checkForUpdates,
      onLaunchUrl: _launchUrl,
    );
  }
}

class _UpdateCheckHeler {
  static Future<AppUpdateInfo?> check(WidgetRef ref) {
    return ref.read(updateServiceProvider).checkForUpdate();
  }
}

class _AboutScreenContent extends ConsumerWidget {
  final String version;
  final VoidCallback onCheckForUpdates;
  final Function(String) onLaunchUrl;

  const _AboutScreenContent({
    required this.version,
    required this.onCheckForUpdates,
    required this.onLaunchUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: NovonColors.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(child: BrandingLogo(size: 62)),
                ),
                const SizedBox(height: 16),
                Text(
                  AppConfig.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  version,
                  style: TextStyle(color: NovonColors.textSecondary),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: NovonColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    AppConfig.status,
                    style: TextStyle(
                      color: NovonColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Open-source novel reader',
                  style: TextStyle(color: NovonColors.textSecondary),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onCheckForUpdates,
                  child: const Text('Check for Updates'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.new_releases_rounded),
            title: const Text('What\'s New'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onLaunchUrl(AppConstants.linkLatestRelease),
          ),
          const Divider(),
          _LinkTile(
            icon: Icons.public,
            title: 'Website',
            url: AppConstants.linkWebsite,
            onTap: onLaunchUrl,
          ),
          _LinkTile(
            icon: Icons.book,
            title: 'Documentation',
            url: AppConstants.linkDocumentation,
            onTap: onLaunchUrl,
          ),
          _LinkTile(
            icon: Icons.chat,
            title: 'Discord Community',
            url: AppConstants.linkDiscord,
            onTap: (_) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Discord invite coming soon.')),
            ),
          ),
          _LinkTile(
            icon: Icons.code,
            title: 'Source Code',
            url: AppConstants.linkSourceCode,
            onTap: onLaunchUrl,
          ),

          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report an Issue'),
            onTap: () => context.go(RouterConstants.moreReport),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              '© ${DateTime.now().year} Novon Contributors\nReleased under the Apache 2.0 License\n\nNovon does not host, distribute, or affiliate with any novel content.\nAll content is sourced from third-party websites via community extensions.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: NovonColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Specialized navigational tile for orchestrating the dispatch of external
/// URIs while maintaining standardized visual presentation.
class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String url;
  final Function(String) onTap;

  const _LinkTile({
    required this.icon,
    required this.title,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.open_in_new, size: 16),
      onTap: () => onTap(url),
    );
  }
}
