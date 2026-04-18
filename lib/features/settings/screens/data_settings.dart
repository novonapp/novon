import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/services/settings_export_service.dart';
import '../../../core/services/storage_path_service.dart';
import '../../statistics/providers/statistics_provider.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import '../../../core/providers/download_provider.dart';

/// Administrative surface for application lifecycle management, facilitating
/// data portability, persistent storage orchestration, and destructive maintenance.
class DataSettingsScreen extends ConsumerStatefulWidget {
  const DataSettingsScreen({super.key});

  @override
  ConsumerState<DataSettingsScreen> createState() => _DataSettingsScreenState();
}

class _DataSettingsScreenState extends ConsumerState<DataSettingsScreen> {
  late Box _box;
  bool _busy = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void initState() {
    super.initState();
    _box = Hive.box(HiveBox.app);
  }

  void _update(String key, dynamic value) {
    _box.put(key, value);
    setState(() {});
  }

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

  /// Orchestrates the serialization and persistent exportation of the current
  /// application configuration to a portable JSON manifest.
  Future<void> _exportSettings() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final svc = ref.read(settingsExportServiceProvider);
      final path = await svc.exportSettings();
      setState(() {
        _message = 'Settings exported to: $path';
        _messageIsError = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Export failed: $e';
        _messageIsError = true;
      });
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _importSettings() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: 'Select novon_settings.json',
    );
    if (result == null || result.files.single.path == null) return;

    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final svc = ref.read(settingsExportServiceProvider);
      await svc.importSettings(result.files.single.path!);
      setState(() {
        _message =
            'Settings imported successfully. Some changes apply on restart.';
        _messageIsError = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Import failed: $e';
        _messageIsError = true;
      });
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _showBackupIntervalDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Auto-Backup Frequency'),
        children: ['off', 'daily', 'weekly'].map((opt) {
          final current = _box.get(
            HiveKeys.autoBackupInterval,
            defaultValue: 'daily',
          );
          return RadioGroup(
            groupValue: current,
            onChanged: (v) {
              _update(HiveKeys.autoBackupInterval, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: Text(opt[0].toUpperCase() + opt.substring(1)),
              value: opt,
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _showRetentionDialog() async {
    final current =
        _box.get(HiveKeys.autoBackupKeepCount, defaultValue: 5) as int;
    await showDialog(
      context: context,
      builder: (ctx) => _IntPickerDialog(
        title: 'Keep Last N Backups',
        min: 1,
        max: 50,
        current: current,
        onSave: (v) => _update(HiveKeys.autoBackupKeepCount, v),
      ),
    );
  }

  Future<bool> _confirmAction({
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: confirmColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result == true;
  }

  Future<void> _clearDirectoryContents(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      return;
    }
    await for (final entity in dir.list(recursive: false, followLinks: false)) {
      try {
        await entity.delete(recursive: true);
      } catch (_) {
        // Continue clearing other entries.
      }
    }
  }

  /// Executes a non-destructive purge of auxiliary cache directories and
  /// ephemeral network response buffers.
  Future<void> _clearAllCache() async {
    final confirmed = await _confirmAction(
      title: 'Clear all cache?',
      message:
          'This will clear chapter HTML cache, image cache, web/session cookies, and temporary files. '
          'Your library, history, and settings will stay.',
      confirmLabel: 'Clear cache',
      confirmColor: NovonColors.primary,
    );
    if (!confirmed) {
      return;
    }

    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      final db = ref.read(databaseProvider);
      final sps = StoragePathService.instance;

      await db.customStatement('DELETE FROM chapter_contents;');
      await _box.put(HiveKeys.chapterHtmlCache, <String, dynamic>{});
      await _box.put(HiveKeys.sourceCookies, <String, dynamic>{});
      await _box.put(HiveKeys.downloadTaskState, <String, dynamic>{});
      await _box.put(HiveKeys.notifChapterUpdates, <String>[]);

      await DefaultCacheManager().emptyCache();
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      if (sps.isConfigured) {
        await _clearDirectoryContents(sps.cacheDir);
        await _clearDirectoryContents(sps.coversDir);
      }

      setState(() {
        _message = 'Cache cleared successfully.';
        _messageIsError = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to clear cache: $e';
        _messageIsError = true;
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  /// Executes a specialized liquidation of all localized chapter content,
  /// effectively forcing a re-fetch upon next access while preserving progress.
  Future<void> _clearChapterCache() async {
    final confirmed = await _confirmAction(
      title: 'Clear chapter cache?',
      message:
          'This will delete all saved chapter content and remove all downloaded chapters. '
          'Your reading progress, history, and library will be preserved.',
      confirmLabel: 'Clear chapters',
      confirmColor: NovonColors.primary,
    );
    if (!confirmed) return;

    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      final db = ref.read(databaseProvider);

      // Clear content table.
      await db.customStatement('DELETE FROM chapter_contents;');
      // Reset downloaded status across all chapters.
      await db.customStatement('UPDATE chapters SET downloaded = 0;');
      // Clear Hive fallback cache.
      await _box.put(HiveKeys.chapterHtmlCache, <String, dynamic>{});

      // Invalidate the download controller state.
      ref.read(chapterDownloadControllerProvider.notifier).clearAllDownloads();

      setState(() {
        _message = 'Chapter content cache cleared.';
        _messageIsError = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to clear chapters: $e';
        _messageIsError = true;
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  /// Performs an exhaustive liquidation of all localized application data,
  /// including databases, assets, and persistent configurations.
  Future<void> _wipeEverything() async {
    final confirmed = await _confirmAction(
      title: 'Wipe everything?',
      message:
          'This will permanently remove library, chapters, history, statistics, downloads state, extension data, and caches. '
          'This cannot be undone.',
      confirmLabel: 'Wipe everything',
      confirmColor: NovonColors.error,
    );
    if (!confirmed) {
      return;
    }

    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      final db = ref.read(databaseProvider);
      final sps = StoragePathService.instance;
      final readerBox = Hive.box(HiveBox.reader);
      final extBox = Hive.box('novon_extensions');

      await db.transaction(() async {
        await db.delete(db.novelCategories).go();
        await db.delete(db.history).go();
        await db.delete(db.chapters).go();
        await db.delete(db.libraryFlags).go();
        await db.delete(db.trackerItems).go();
        await db.delete(db.novels).go();
        await db.delete(db.categories).go();
      });
      await db.customStatement('DELETE FROM chapter_contents;');

      await _box.clear();
      await readerBox.clear();
      await extBox.clear();

      await DefaultCacheManager().emptyCache();
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      if (sps.isConfigured) {
        await _clearDirectoryContents(sps.cacheDir);
        await _clearDirectoryContents(sps.coversDir);
        await _clearDirectoryContents(sps.downloadsDir);
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _message = 'All local app data has been wiped.';
        _messageIsError = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _message = 'Failed to wipe data: $e';
        _messageIsError = true;
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
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
    final interval =
        _box.get(HiveKeys.autoBackupInterval, defaultValue: 'daily') as String;
    final keepCount =
        _box.get(HiveKeys.autoBackupKeepCount, defaultValue: 5) as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Data & Storage')),
      body: ListView(
        children: [
          if (_message != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    (_messageIsError ? NovonColors.error : NovonColors.success)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _message!,
                style: TextStyle(
                  color: _messageIsError
                      ? NovonColors.error
                      : NovonColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          ListTile(
            leading: const Icon(Icons.folder_special_rounded),
            title: const Text('Storage Location'),
            subtitle: Text(
              storageDisplay ?? 'Not set',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: FilledButton.tonal(
              onPressed: _pickStorageFolder,
              child: const Text('Change'),
            ),
          ),
          const Divider(height: 1),

          SwitchListTile(
            secondary: const Icon(Icons.backup_rounded),
            title: const Text('Auto-Backup'),
            value: _box.get(HiveKeys.autoBackupEnabled, defaultValue: true),
            onChanged: (val) => _update(HiveKeys.autoBackupEnabled, val),
          ),
          ListTile(
            leading: const Icon(Icons.schedule_rounded),
            title: const Text('Auto-Backup Frequency'),
            subtitle: Text(interval[0].toUpperCase() + interval.substring(1)),
            onTap: _showBackupIntervalDialog,
          ),
          ListTile(
            leading: const Icon(Icons.filter_list_rounded),
            title: const Text('Auto-Backup Retention'),
            subtitle: Text('Keep last $keepCount backups'),
            onTap: _showRetentionDialog,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.cloud_sync_rounded),
            title: const Text('WebDAV Sync'),
            subtitle: const Text('Sync backups to a WebDAV server'),
            value: _box.get(HiveKeys.webdavEnabled, defaultValue: false),
            onChanged: (val) => _update(HiveKeys.webdavEnabled, val),
          ),
          const Divider(),

          // Backup & Restore
          ListTile(
            leading: const Icon(Icons.backup_rounded),
            title: const Text('Backup & Restore'),
            subtitle: const Text('Manage manual and auto backups'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.go('/more/settings/data/backup'),
          ),
          const Divider(),

          // Settings Export / Import
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Settings Portability',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: NovonColors.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Export your settings to novon_settings.json so others can import your exact configuration, or import someone else\'s setup.',
              style: TextStyle(color: NovonColors.textSecondary, fontSize: 13),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.upload_rounded),
            title: const Text('Export Settings'),
            subtitle: const Text(
              'Save to novon_settings.json in your app folder',
            ),
            trailing: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: ShimmerLoading(
                      width: 20,
                      height: 20,
                      borderRadius: 999,
                    ),
                  )
                : null,
            onTap: _busy ? null : _exportSettings,
          ),
          ListTile(
            leading: const Icon(Icons.download_rounded),
            title: const Text('Import Settings'),
            subtitle: const Text('Load a novon_settings.json file'),
            trailing: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: ShimmerLoading(
                      width: 20,
                      height: 20,
                      borderRadius: 999,
                    ),
                  )
                : null,
            onTap: _busy ? null : _importSettings,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Danger Zone',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: NovonColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_rounded),
            title: const Text('Clear all cache'),
            subtitle: const Text('Clears chapter/image/session caches only'),
            trailing: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: ShimmerLoading(
                      width: 20,
                      height: 20,
                      borderRadius: 999,
                    ),
                  )
                : null,
            onTap: _busy ? null : _clearAllCache,
          ),
          ListTile(
            leading: const Icon(Icons.auto_delete_rounded),
            title: const Text('Clear chapter content'),
            subtitle: const Text('Delete all saved chapters and cached text'),
            trailing: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: ShimmerLoading(
                      width: 20,
                      height: 20,
                      borderRadius: 999,
                    ),
                  )
                : null,
            onTap: _busy ? null : _clearChapterCache,
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever_rounded,
              color: NovonColors.error,
            ),
            title: const Text('Wipe everything'),
            subtitle: const Text('Delete all local app data permanently'),
            trailing: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: ShimmerLoading(
                      width: 20,
                      height: 20,
                      borderRadius: 999,
                    ),
                  )
                : null,
            onTap: _busy ? null : _wipeEverything,
          ),
          const SizedBox(height: 24),
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
