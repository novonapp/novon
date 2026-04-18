import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novon/core/common/enums/chapter_download_status.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/widgets/novel_cover_image.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/download_provider.dart';
import 'package:novon/core/common/constants/router_constants.dart';

/// Management interface for background content acquisition, orchestrating
/// granular control over the download queue and localized storage synchronization.
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadItemsProvider);
    final tasks = ref.watch(chapterDownloadControllerProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Downloads'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) async {
                if (value == 'clear_all') {
                  final confirmed = await _showConfirmDialog(
                    context,
                    title: 'Clear all downloads?',
                    message:
                        'This will permanently delete all downloaded chapters and their content.',
                    confirmLabel: 'Clear All',
                    isDanger: true,
                  );
                  if (confirmed) {
                    ref
                        .read(chapterDownloadControllerProvider.notifier)
                        .clearAllDownloads();
                  }
                } else if (value == 'clear_completed') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Taps on chapter icons to remove individual downloads',
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'pause_all',
                  child: Text('Pause All'),
                ),
                const PopupMenuItem(
                  value: 'resume_all',
                  child: Text('Resume All'),
                ),
                const PopupMenuItem(
                  value: 'clear_completed',
                  child: Text('Clear Completed'),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: NovonColors.error),
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: NovonColors.primary,
            labelColor: NovonColors.primary,
            unselectedLabelColor: NovonColors.textSecondary,
            dividerColor: NovonColors.divider,
            tabs: [
              Tab(text: 'Queue'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildQueueTab(context, downloads, tasks),
            _buildCompletedTab(context, downloads, tasks),
          ],
        ),
      ),
    );
  }

  /// Orchestrates the assembly of the reactive queue surface, apprising
  /// active, queued, or stalled acquisition tasks.
  Widget _buildQueueTab(
    BuildContext context,
    AsyncValue<List<DownloadItemVm>> downloads,
    Map<String, ChapterDownloadInfo> tasks,
  ) {
    return downloads.when(
      loading: () => const CoverListShimmer(),
      error: (e, st) => Center(child: Text('Failed to load downloads: $e')),
      data: (items) {
        final queue = items.where((i) {
          final t = tasks[i.chapterId];
          return t != null && t.status != ChapterDownloadStatus.complete;
        }).toList();
        if (queue.isNotEmpty) {
          return ListView.separated(
            itemCount: queue.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final d = queue[index];
              return ListTile(
                leading: NovelCoverImage(
                  imageUrl: d.novelCoverUrl,
                  width: 42,
                  height: 56,
                  borderRadius: 8,
                ),
                title: Text(
                  d.novelTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  d.chapterName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: () {
                  final t = tasks[d.chapterId];
                  if (t == null) return null;
                  if (t.status == ChapterDownloadStatus.downloading ||
                      t.status == ChapterDownloadStatus.queued) {
                    return SizedBox(
                      width: 20,
                      height: 20,
                      child: const ShimmerLoading(
                        width: 20,
                        height: 20,
                        borderRadius: 999,
                      ),
                    );
                  }
                  if (t.status == ChapterDownloadStatus.failed) {
                    return Icon(
                      Icons.error_outline_rounded,
                      color: NovonColors.error,
                    );
                  }
                  return null;
                }(),
                onTap: () => context.push(
                  RouterConstants.novelDetail(d.sourceId, d.novelUrl),
                ),
              );
            },
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: NovonColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.download_done_rounded,
                  color: NovonColors.textTertiary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Download queue is empty',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: NovonColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Queued chapters will appear here',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: NovonColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Orchestrates the assembly of the archival view for content segments
  /// successfully persisted to the localized asset store.
  Widget _buildCompletedTab(
    BuildContext context,
    AsyncValue<List<DownloadItemVm>> downloads,
    Map<String, ChapterDownloadInfo> tasks,
  ) {
    return downloads.when(
      loading: () => const CoverListShimmer(),
      error: (e, st) => Center(child: Text('Failed to load downloads: $e')),
      data: (items) {
        final completed = items.where((i) {
          final t = tasks[i.chapterId];
          return t != null && t.status == ChapterDownloadStatus.complete;
        }).toList();
        if (completed.isNotEmpty) {
          return ListView.separated(
            itemCount: completed.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final d = completed[index];
              return ListTile(
                leading: NovelCoverImage(
                  imageUrl: d.novelCoverUrl,
                  width: 42,
                  height: 56,
                  borderRadius: 8,
                ),
                title: Text(
                  d.novelTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  d.chapterName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Consumer(
                  builder: (context, ref, _) {
                    return GestureDetector(
                      onTap: () async {
                        final confirmed = await _showConfirmDialog(
                          context,
                          title: 'Delete download?',
                          message:
                              'Are you sure you want to remove this chapter?',
                          confirmLabel: 'Delete',
                          isDanger: true,
                        );
                        if (confirmed) {
                          ref
                              .read(chapterDownloadControllerProvider.notifier)
                              .removeDownload(d.chapterId);
                        }
                      },
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: NovonColors.success,
                      ),
                    );
                  },
                ),
                onTap: () => context.push(
                  RouterConstants.novelDetail(d.sourceId, d.novelUrl),
                ),
              );
            },
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: NovonColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.folder_open_rounded,
                  color: NovonColors.textTertiary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No completed downloads',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: NovonColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Downloaded chapters will appear here',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: NovonColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    bool isDanger = false,
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
            style: isDanger
                ? FilledButton.styleFrom(backgroundColor: NovonColors.error)
                : null,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
