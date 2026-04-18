import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/novon_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/common/widgets/novel_cover_image.dart';
import 'package:novon/core/common/constants/router_constants.dart';

import '../widgets/history_shimmer.dart';

/// Chronological audit surface for user content consumption, orchestrating
/// direct access to recently read segments and session-based progress records.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyItemsProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('History'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                onPressed: () => _showClearDialog(context, ref),
              ),
            ],
          ),
          history.when(
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: HistoryShimmer(),
            ),
            error: (e, st) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Failed to load history: $e')),
            ),
            data: (items) {
              if (items.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context),
                );
              }

              return SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final h = items[index];
                  final chapterLabel = h.chapterNumber > 0
                      ? 'Ch. ${h.chapterNumber.toStringAsFixed(h.chapterNumber % 1 == 0 ? 0 : 1)} - ${h.chapterName}'
                      : h.chapterName;
                  return ListTile(
                    leading: NovelCoverImage(
                      imageUrl: h.novelCoverUrl,
                      width: 42,
                      height: 56,
                      borderRadius: 8,
                    ),
                    title: Text(
                      h.novelTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '$chapterLabel\nLast read: ${DateFormat.yMMMd().add_jm().format(h.readAt)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => context.push(
                      RouterConstants.reader(
                        h.sourceId,
                        h.novelUrl,
                        h.chapterId,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Specialized UI assembly for terminal states where the historical
  /// archival index is empty.
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    NovonColors.accent.withValues(alpha: 0.15),
                    NovonColors.warning.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.history_rounded,
                color: NovonColors.accent,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No reading history',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: NovonColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chapters you read will be\nrecorded here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: NovonColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Orchestrates the decommissioning of the entire historical archival state
  /// via a localized user-confirmation interface.
  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text(
          'This will remove all reading history. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(historyRepositoryProvider).clearAllHistory();
              if (context.mounted) context.pop();
            },
            style: FilledButton.styleFrom(backgroundColor: NovonColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
