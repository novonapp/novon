import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/services/storage_path_service.dart';
import '../../../core/theme/novon_colors.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// Networking orchestration interface for managing request metadata, DNS
/// resolution strategies, and anti-bot mitigation methodologies.
class NetworkSettingsScreen extends ConsumerStatefulWidget {
  const NetworkSettingsScreen({super.key});

  @override
  ConsumerState<NetworkSettingsScreen> createState() =>
      _NetworkSettingsScreenState();
}

class _NetworkSettingsScreenState extends ConsumerState<NetworkSettingsScreen> {
  late Box _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box(HiveBox.app);
  }

  void _update(String key, dynamic value) {
    _box.put(key, value);
    setState(() {});
  }

  /// Performs a destructive purge of the persistent HTTP cache directory,
  /// necessitating re-acquisition of remote resources upon subsequent requests.
  Future<void> _clearHttpCache() async {
    bool cleared = false;
    final sps = StoragePathService.instance;
    if (sps.isConfigured) {
      try {
        final cacheDir = Directory(sps.cacheDir);
        if (await cacheDir.exists()) {
          await cacheDir.delete(recursive: true);
          await cacheDir.create();
        }
        cleared = true;
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cleared
                ? 'HTTP cache cleared'
                : 'HTTP cache cleared (no persistent store found)',
          ),
          backgroundColor: NovonColors.success,
        ),
      );
    }
  }

  void _showUserAgentDialog() {
    final tc = TextEditingController(
      text: _box.get(
        HiveKeys.globalUserAgent,
        defaultValue:
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      ),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Global User-Agent'),
        content: TextField(
          controller: tc,
          decoration: const InputDecoration(
            hintText: 'Enter User-Agent string',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              _update(HiveKeys.globalUserAgent, tc.text.trim());
              ctx.pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDohDialog() {
    final current =
        _box.get(HiveKeys.dohProvider, defaultValue: 'system') as String;
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('DNS-over-HTTPS Provider'),
        children: [
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              _update(HiveKeys.dohProvider, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('System default'),
              value: 'system',
            ),
          ),
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              _update(HiveKeys.dohProvider, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('Cloudflare (1.1.1.1)'),
              value: 'cloudflare',
            ),
          ),
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              _update(HiveKeys.dohProvider, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('Google (8.8.8.8)'),
              value: 'google',
            ),
          ),
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              _update(HiveKeys.dohProvider, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('Quad9'),
              value: 'quad9',
            ),
          ),
        ],
      ),
    );
  }

  /// Displays a selection surface for defining the strategy used to
  /// circumnavigate CDN-level security challenges.
  void _showCfBypassDialog() {
    final current =
        _box.get(HiveKeys.cfBypassMode, defaultValue: 'auto') as String;
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Cloudflare Bypass Mode'),
        children: [
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              _update(HiveKeys.cfBypassMode, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('Auto'),
              subtitle: const Text('Try headers first, fallback to WebView'),
              value: 'auto',
            ),
          ),
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              _update(HiveKeys.cfBypassMode, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('Aggressive'),
              subtitle: const Text('Spoof full browser fingerprint'),
              value: 'aggressive',
            ),
          ),
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              _update(HiveKeys.cfBypassMode, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('WebView'),
              subtitle: const Text('Open in WebView to solve challenge'),
              value: 'webview',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network & User-Agent')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.computer_rounded),
            title: const Text('Global User-Agent'),
            subtitle: Text(
              _box.get(
                HiveKeys.globalUserAgent,
                defaultValue: 'Mozilla/5.0...',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.edit_rounded, size: 18),
            onTap: _showUserAgentDialog,
          ),
          ListTile(
            leading: const Icon(Icons.dns_rounded),
            title: const Text('DNS-over-HTTPS'),
            subtitle: Text(
              _box.get(HiveKeys.dohProvider, defaultValue: 'system'),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: _showDohDialog,
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.cached_rounded),
            title: const Text('Enable HTTP Cache'),
            subtitle: const Text('Cache web responses to reduce data usage'),
            value: _box.get(HiveKeys.httpCacheEnabled, defaultValue: true),
            onChanged: (val) => _update(HiveKeys.httpCacheEnabled, val),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep_rounded),
            title: const Text('Clear HTTP Cache'),
            subtitle: const Text('Remove all cached network responses'),
            onTap: _clearHttpCache,
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.vpn_lock_rounded),
            title: const Text('Proxy'),
            subtitle: const Text('Route traffic through a proxy server'),
            value: _box.get(HiveKeys.proxyEnabled, defaultValue: false),
            onChanged: (val) => _update(HiveKeys.proxyEnabled, val),
          ),
          ListTile(
            leading: const Icon(Icons.shield_moon_rounded),
            title: const Text('Cloudflare Bypass Mode'),
            subtitle: Text(
              _box.get(HiveKeys.cfBypassMode, defaultValue: 'auto'),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: _showCfBypassDialog,
          ),
        ],
      ),
    );
  }
}
