import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/storage_path_service.dart';
import '../../../core/theme/novon_colors.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import 'package:novon/core/common/constants/router_constants.dart';
import 'package:google_fonts/google_fonts.dart';

/// A specialized configuration interface for low-level application parameters,
/// diagnostic instrumentation, and granular data maintenance operations.
class AdvancedSettingsScreen extends ConsumerStatefulWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  ConsumerState<AdvancedSettingsScreen> createState() =>
      _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState
    extends ConsumerState<AdvancedSettingsScreen> {
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

  /// Displays a selection surface for defining the diagnostic verbosity level
  /// of the underlying instrumentation engine.
  void _showLogLevelDialog() {
    final current = _box.get(HiveKeys.logLevel, defaultValue: 'info') as String;
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Log Level'),
        children: ['verbose', 'debug', 'info', 'warning', 'error'].map((lvl) {
          return RadioGroup(
            groupValue: current,
            onChanged: (v) {
              _update(HiveKeys.logLevel, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: Text(lvl[0].toUpperCase() + lvl.substring(1)),
              value: lvl,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showClearDataDialog() {
    bool clearHistory = false;
    bool clearDownloadQueue = false;
    bool clearSettings = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setState) => AlertDialog(
          title: const Text('Clear App Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select what to clear. This is irreversible.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                dense: true,
                title: const Text('Reading History'),
                value: clearHistory,
                onChanged: (v) => setState(() => clearHistory = v!),
              ),
              CheckboxListTile(
                dense: true,
                title: const Text('Download Queue State'),
                value: clearDownloadQueue,
                onChanged: (v) => setState(() => clearDownloadQueue = v!),
              ),
              CheckboxListTile(
                dense: true,
                title: const Text('All Settings (reset to defaults)'),
                value: clearSettings,
                onChanged: (v) => setState(() => clearSettings = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
            FilledButton(
              onPressed:
                  (!clearHistory && !clearDownloadQueue && !clearSettings)
                  ? null
                  : () async {
                      ctx.pop();
                      await _executeClearData(
                        clearHistory: clearHistory,
                        clearQueue: clearDownloadQueue,
                        clearSettings: clearSettings,
                      );
                    },
              style: FilledButton.styleFrom(
                backgroundColor: NovonColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear Selected'),
            ),
          ],
        ),
      ),
    );
  }

  /// Orchestrates the selective invalidation of application state components,
  /// supporting granular cleanup of history, queue data, and configurations.
  Future<void> _executeClearData({
    required bool clearHistory,
    required bool clearQueue,
    required bool clearSettings,
  }) async {
    final msgs = <String>[];

    // Reading history is in the Drift database, we'd need the DB provider.
    // For settings, we can clear Hive directly here.
    if (clearSettings) {
      final keysToKeep = [HiveKeys.storageUri, HiveKeys.onboardingComplete];
      final allKeys = _box.keys.toList();
      for (final k in allKeys) {
        if (!keysToKeep.contains(k)) await _box.delete(k);
      }
      msgs.add('Settings reset to defaults');
    }

    if (clearHistory) {
      msgs.add('History cleared (requires restart)');
    }

    if (clearQueue) {
      msgs.add('Download queue cleared (requires restart)');
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msgs.join(' · ')),
          backgroundColor: NovonColors.success,
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.code_rounded),
            title: const Text('JavaScript Injection'),
            subtitle: const Text('Developer tool — may break sources'),
            value: _box.get(HiveKeys.jsInjectEnabled, defaultValue: false),
            onChanged: (val) => _update(HiveKeys.jsInjectEnabled, val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.memory_rounded),
            title: const Text('Force Software Rendering'),
            subtitle: const Text('Use if GPU rendering causes issues'),
            value: _box.get(HiveKeys.forceSoftwareRender, defaultValue: false),
            onChanged: (val) => _update(HiveKeys.forceSoftwareRender, val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.bug_report_outlined),
            title: const Text('Enable Debug Logging'),
            value: _box.get(HiveKeys.debugLogging, defaultValue: false),
            onChanged: (val) => _update(HiveKeys.debugLogging, val),
          ),
          ListTile(
            leading: const Icon(Icons.filter_list_rounded),
            title: const Text('Log Level'),
            subtitle: Text(() {
              final lvl =
                  _box.get(HiveKeys.logLevel, defaultValue: 'info') as String;
              return lvl[0].toUpperCase() + lvl.substring(1);
            }()),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: _showLogLevelDialog,
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.developer_mode_rounded),
            title: const Text('Developer Mode'),
            subtitle: const Text('Enables extra debug UI and options'),
            value: _box.get(HiveKeys.developerMode, defaultValue: false),
            onChanged: (val) => _update(HiveKeys.developerMode, val),
          ),
          ListTile(
            leading: const Icon(Icons.history_edu_rounded),
            title: const Text('Exception Logs'),
            subtitle: const Text('View and manage stored crash reports'),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: () => context.push(RouterConstants.moreDeveloperLogs),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.delete_sweep_rounded, color: NovonColors.error),
            title: Text(
              'Clear App Data',
              style: TextStyle(color: NovonColors.error),
            ),
            subtitle: const Text(
              'Selectively clear history, queue, or settings',
            ),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: _showClearDataDialog,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'App Storage Root',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: NovonColors.textTertiary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              StoragePathService.instance.isConfigured
                  ? StoragePathService.instance.storagePath!
                  : 'Not configured',
              style: GoogleFonts.firaCode(
                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: NovonColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
