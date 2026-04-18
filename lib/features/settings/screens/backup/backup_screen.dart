import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/novon_colors.dart';
import '../../../../core/common/widgets/shimmer_loading.dart';
import '../../../../core/services/backup_service.dart';
import '../../../../core/services/storage_path_service.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// Centralized orchestration interface for application data archival, 
/// facilitating the creation, restoration, and management of compressed snapshots.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _isCreating = false;
  bool _isRestoring = false;
  String? _message;
  bool _messageIsError = false;
  List<FileSystemEntity> _backupFiles = [];

  @override
  void initState() {
    super.initState();
    _loadBackupList();
  }

  Future<void> _loadBackupList() async {
    final svc = ref.read(backupServiceProvider);
    final files = await svc.listBackups();
    if (mounted) setState(() => _backupFiles = files);
  }

  /// Orchestrates the creation of a compressed archival snapshot of the 
  /// current application state, including localized metadata and configurations.
  Future<void> _createBackup() async {
    setState(() {
      _isCreating = true;
      _message = null;
      _messageIsError = false;
    });
    try {
      final svc = ref.read(backupServiceProvider);
      final path = await svc.createBackup();

      // Auto-prune based on keep-count setting
      final keepCount =
          Hive.box(
                HiveBox.app,
              ).get(HiveKeys.autoBackupKeepCount, defaultValue: 5)
              as int;
      await svc.pruneOldBackups(keepCount);

      await _loadBackupList();
      setState(() {
        _message = 'Backup saved: ${_filename(path)}';
        _messageIsError = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
        _messageIsError = true;
      });
    } finally {
      setState(() => _isCreating = false);
    }
  }

  /// Facilitates the restoration of application state from an external 
  /// archival manifest, requiring critical validation before commitment.
  Future<void> _restoreFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gz'],
      dialogTitle: 'Select Novon Backup File',
    );
    if (result == null || result.files.single.path == null) return;

    final confirmed = await _confirmDialog(
      'Restore Backup',
      'This will replace your current library, history, and settings with the data in this backup. This cannot be undone.',
      'Restore',
    );
    if (!confirmed) return;

    setState(() {
      _isRestoring = true;
      _message = null;
      _messageIsError = false;
    });
    try {
      final svc = ref.read(backupServiceProvider);
      await svc.restoreBackup(result.files.single.path!);
      setState(() {
        _message =
            'Backup restored successfully. Restart may be needed for all changes to apply.';
        _messageIsError = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Restore failed: $e';
        _messageIsError = true;
      });
    } finally {
      setState(() => _isRestoring = false);
    }
  }

  Future<void> _restoreFromListItem(FileSystemEntity file) async {
    final confirmed = await _confirmDialog(
      'Restore This Backup',
      'This will replace your current library, history, and settings. Continue?',
      'Restore',
    );
    if (!confirmed) return;

    setState(() {
      _isRestoring = true;
      _message = null;
    });
    try {
      final svc = ref.read(backupServiceProvider);
      await svc.restoreBackup(file.path);
      setState(() {
        _message = 'Restored from ${_filename(file.path)}';
        _messageIsError = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Restore failed: $e';
        _messageIsError = true;
      });
    } finally {
      setState(() => _isRestoring = false);
    }
  }

  Future<void> _deleteBackup(FileSystemEntity file) async {
    final confirmed = await _confirmDialog(
      'Delete Backup',
      'Delete ${_filename(file.path)}? This cannot be undone.',
      'Delete',
    );
    if (!confirmed) return;
    try {
      await file.delete();
      await _loadBackupList();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }

  Future<bool> _confirmDialog(String title, String body, String action) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: FilledButton.styleFrom(
                  backgroundColor: action == 'Delete'
                      ? NovonColors.error
                      : NovonColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(action),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _filename(String path) => path.split('/').last.split('\\').last;

  String _formatDate(String filename) {
    try {
      final token = filename
          .replaceAll('novon_backup_', '')
          .replaceAll('.json.gz', '');
      final dt = DateFormat('yyyyMMdd_HHmmss').parse(token);
      return DateFormat('MMM d, yyyy — h:mm a').format(dt);
    } catch (_) {
      return filename;
    }
  }

  Future<int> _fileSize(FileSystemEntity f) async {
    try {
      return await (f as File).length();
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sps = StoragePathService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Backups')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Storage location info
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: NovonColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: NovonColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  color: NovonColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    sps.isConfigured
                        ? 'Backups folder: ${sps.backupsDir}'
                        : 'Storage not configured',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NovonColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Message banner
          if (_message != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
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

          // Create Backup card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: NovonColors.surfaceVariant.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.backup_rounded, color: NovonColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Create Backup',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Backs up your library, history, downloaded chapters metadata, and all settings into a compressed .json.gz file.',
                    style: TextStyle(
                      color: NovonColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isCreating ? null : _createBackup,
                    icon: _isCreating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: ShimmerLoading(width: 16, height: 16, borderRadius: 999),
                          )
                        : const Icon(Icons.save_alt_rounded),
                    label: const Text('Create Backup Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NovonColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Restore from file
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: NovonColors.surfaceVariant.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restore_rounded, color: NovonColors.accent),
                      const SizedBox(width: 12),
                      Text(
                        'Restore from File',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pick any .json.gz backup file from your device to restore.',
                    style: TextStyle(
                      color: NovonColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _isRestoring ? null : _restoreFromFile,
                    icon: _isRestoring
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: ShimmerLoading(width: 16, height: 16, borderRadius: 999),
                          )
                        : const Icon(Icons.upload_file_rounded),
                    label: const Text('Browse & Restore'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Backup history list
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved Backups (${_backupFiles.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 18),
                onPressed: _loadBackupList,
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_backupFiles.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No backups found. Create your first backup above.',
                  style: TextStyle(color: NovonColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...List.generate(_backupFiles.length, (i) {
              final file = _backupFiles[i];
              final name = _filename(file.path);
              return FutureBuilder<int>(
                future: _fileSize(file),
                builder: (ctx, snap) {
                  final size = snap.hasData
                      ? StoragePathService.formatBytes(snap.data!)
                      : '...';
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.archive_rounded,
                        color: NovonColors.primary,
                      ),
                      title: Text(
                        _formatDate(name),
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        size,
                        style: TextStyle(
                          color: NovonColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.restore_rounded,
                              color: NovonColors.primary,
                              size: 20,
                            ),
                            onPressed: () => _restoreFromListItem(file),
                            tooltip: 'Restore',
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: NovonColors.error,
                              size: 20,
                            ),
                            onPressed: () => _deleteBackup(file),
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
