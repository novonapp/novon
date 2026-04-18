import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/models/app_update_info.dart';
import '../../../core/services/update_service.dart';

/// Elevated interface for reviewing and orchestrating application updates,
/// providing detailed version insights and real-time interaction with the
/// background download subsystem.
class AppUpdateScreen extends ConsumerStatefulWidget {
  final AppUpdateInfo updateInfo;

  const AppUpdateScreen({super.key, required this.updateInfo});

  @override
  ConsumerState<AppUpdateScreen> createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends ConsumerState<AppUpdateScreen> {
  double _progress = 0;
  bool _isDownloading = false;
  bool _isDownloaded = false;
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    final downloadUpdates = ref.watch(appUpdateDownloadProvider);

    downloadUpdates.whenData((update) {
      if (update is TaskProgressUpdate) {
        setState(() {
          _progress = update.progress;
          _isDownloading = true;
        });
      } else if (update is TaskStatusUpdate) {
        if (update.status == TaskStatus.complete) {
          _handleDownloadComplete();
        } else if (update.status == TaskStatus.failed) {
          _handleDownloadFailed();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Update Available'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  Text(
                    'What\'s New',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NovonColors.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NovonColors.divider),
                    ),
                    child: MarkdownBody(
                      data: widget.updateInfo.changelog,
                      selectable: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomAction(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: NovonColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.system_update_rounded,
            color: NovonColors.primary,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.updateInfo.tagName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Size: ${_formatSize(widget.updateInfo.size)}',
                style: TextStyle(color: NovonColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isDownloading) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
                backgroundColor: NovonColors.lightSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Downloading... ${(_progress * 100).toInt()}%',
              style: TextStyle(
                color: NovonColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Later'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isDownloaded ? _installUpdate : _startDownload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NovonColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isDownloaded ? 'Install Now' : 'Update Now'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _startDownload() async {
    setState(() {
      _isDownloading = true;
    });
    await ref.read(updateServiceProvider).downloadUpdate(widget.updateInfo);
  }

  void _installUpdate() async {
    if (_filePath != null) {
      try {
        await ref.read(updateServiceProvider).installUpdate(_filePath!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Installation failed: $e')));
        }
      }
    }
  }

  void _handleDownloadComplete() async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${widget.updateInfo.fileName}';
    setState(() {
      _isDownloading = false;
      _isDownloaded = true;
      _filePath = path;
    });
  }

  void _handleDownloadFailed() {
    setState(() {
      _isDownloading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download failed. Please try again.')),
      );
    }
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return 'Unknown';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
}
