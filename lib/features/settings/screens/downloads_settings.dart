import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/services/storage_path_service.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// Configuration interface for asset persistence and localized storage
/// orchestration, allowing for the granular management of content acquisition parameters.
class DownloadsSettingsScreen extends ConsumerStatefulWidget {
  const DownloadsSettingsScreen({super.key});

  @override
  ConsumerState<DownloadsSettingsScreen> createState() =>
      _DownloadsSettingsScreenState();
}

class _DownloadsSettingsScreenState
    extends ConsumerState<DownloadsSettingsScreen> {
  late Box _box;
  int? _totalBytes;
  bool _calculating = false;
  int? _coverBytes;

  @override
  void initState() {
    super.initState();
    _box = Hive.box(HiveBox.app);
    _calculateSizes();
  }

  void _update(String key, dynamic value) {
    _box.put(key, value);
    setState(() {});
  }

  Future<void> _calculateSizes() async {
    setState(() => _calculating = true);
    final sps = StoragePathService.instance;
    if (sps.isConfigured) {
      final total = await sps.calculateTotalSize();
      final covers = await sps.calculateDirSize(sps.coversDir);
      if (mounted) {
        setState(() {
          _totalBytes = total;
          _coverBytes = covers;
          _calculating = false;
        });
      }
    } else {
      if (mounted) setState(() => _calculating = false);
    }
  }

  /// Invokes a platform-native directory selector to redefine the primary
  /// persistent storage location for acquired content segments.
  Future<void> _pickStorageFolder() async {
    try {
      final newPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select your Novon folder',
      );
      if (newPath == null) return;

      final sps = StoragePathService.instance;
      await sps.setStoragePath(newPath);
      await sps.ensureDirectoriesExist();
      _update(HiveKeys.storageUri, newPath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Storage location updated to: $newPath'),
            backgroundColor: NovonColors.success,
          ),
        );
        _calculateSizes();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change location: $e'),
            backgroundColor: NovonColors.error,
          ),
        );
      }
    }
  }

  /// Performs a destructive purge of localized cover assets and evicts
  /// related entries from the ephemeral network image cache.
  Future<void> _clearCoverCache() async {
    await CachedNetworkImage.evictFromCache('');
    // Also clear covers directory
    final sps = StoragePathService.instance;
    if (sps.isConfigured) {
      final dir = Directory(sps.coversDir);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await dir.create();
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cover cache cleared')));
      _calculateSizes();
    }
  }

  Future<void> _showConcurrentDialog() async {
    final current =
        _box.get(HiveKeys.downloadConcurrent, defaultValue: 2) as int;
    await showDialog(
      context: context,
      builder: (ctx) => _IntPickerDialog(
        title: 'Simultaneous Downloads',
        min: 1,
        max: 10,
        current: current,
        onSave: (v) => _update(HiveKeys.downloadConcurrent, v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sps = StoragePathService.instance;
    final storageDisplay =
        _box.get(
              HiveKeys.storageUri,
              defaultValue: sps.isConfigured ? sps.storagePath : 'Not set',
            )
            as String?;

    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Download Location'),
            subtitle: Text(
              storageDisplay ?? 'Not set — tap to configure',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: FilledButton.tonal(
              onPressed: _pickStorageFolder,
              child: const Text('Change'),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.layers_rounded),
            title: const Text('Simultaneous Downloads'),
            subtitle: Text(
              _box.get(HiveKeys.downloadConcurrent, defaultValue: 2).toString(),
            ),
            onTap: _showConcurrentDialog,
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.image_outlined),
            title: const Text('Download Images Inside Chapters'),
            value: _box.get(HiveKeys.downloadIncludeImages, defaultValue: true),
            onChanged: (val) => _update(HiveKeys.downloadIncludeImages, val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.wifi_rounded),
            title: const Text('Only Download on Wi-Fi'),
            value: _box.get(HiveKeys.downloadWifiOnly, defaultValue: true),
            onChanged: (val) => _update(HiveKeys.downloadWifiOnly, val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.auto_delete_outlined),
            title: const Text('Auto-Delete After Reading'),
            value: _box.get(HiveKeys.downloadAutoDelete, defaultValue: false),
            onChanged: (val) => _update(HiveKeys.downloadAutoDelete, val),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Icon(Icons.storage_rounded, color: NovonColors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _calculating
                        ? 'Calculating total Novon data…'
                        : _totalBytes == null
                        ? 'Storage location not set'
                        : 'Total Novon data: ${StoragePathService.formatBytes(_totalBytes!)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: NovonColors.textSecondary,
                    ),
                  ),
                ),
                if (_calculating)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: ShimmerLoading(
                      width: 16,
                      height: 16,
                      borderRadius: 999,
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    onPressed: _calculateSizes,
                    tooltip: 'Recalculate',
                  ),
              ],
            ),
          ),
          if (_coverBytes != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Cover images: ${StoragePathService.formatBytes(_coverBytes!)}',
                style: TextStyle(
                  color: NovonColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton.icon(
              onPressed: _clearCoverCache,
              icon: const Icon(Icons.delete_sweep_rounded),
              label: Text(
                _coverBytes != null
                    ? 'Clear Cover Cache (${StoragePathService.formatBytes(_coverBytes!)})'
                    : 'Clear Cover Cache',
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _IntPickerDialog extends StatefulWidget {
  final String title;
  final int min;
  final int max;
  final int current;
  final ValueChanged<int> onSave;

  const _IntPickerDialog({
    required this.title,
    required this.min,
    required this.max,
    required this.current,
    required this.onSave,
  });

  @override
  State<_IntPickerDialog> createState() => _IntPickerDialogState();
}

class _IntPickerDialogState extends State<_IntPickerDialog> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _value > widget.min
                ? () => setState(() => _value--)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '$_value',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _value < widget.max
                ? () => setState(() => _value++)
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            widget.onSave(_value);
            context.pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
