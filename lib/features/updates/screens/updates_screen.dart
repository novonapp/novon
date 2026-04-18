import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/theme/novon_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/common/widgets/novel_cover_image.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

import 'package:novon/core/common/constants/router_constants.dart';

/// Centralized notification interface for tracking and consuming newly 
/// discovered content segments from the user's localized library.
class UpdatesScreen extends ConsumerWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updates = ref.watch(updatesItemsProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Updates'),
            actions: [
              IconButton(
                tooltip: 'Mark all as read',
                icon: const Icon(Icons.done_all_rounded),
                onPressed: () async {
                  final current = updates.valueOrNull ?? const <UpdateItemVm>[];
                  final box = Hive.box(HiveBox.app);
                  final raw = box.get(HiveKeys.updatesSeenChapterIds);
                  final seen = raw is List
                      ? raw.map((e) => e.toString()).toSet()
                      : <String>{};
                  for (final item in current) {
                    seen.add(item.chapterId);
                  }
                  await box.put(
                    HiveKeys.updatesSeenChapterIds,
                    seen.toList(growable: false),
                  );
                  ref.read(updatesSeenRevisionProvider.notifier).state++;
                  ref.invalidate(updatesItemsProvider);
                  ref.invalidate(unreadUpdatesCountProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All updates marked as seen')),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  // For now, UI reflects DB state. A real network sync job can be added next.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Updates are shown from your local database')),
                  );
                },
              ),
            ],
          ),
          updates.when(
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: CoverListShimmer(),
            ),
            error: (e, st) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Failed to load updates: $e')),
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
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final u = items[index];
                  return ListTile(
                    leading: NovelCoverImage(
                      imageUrl: u.novelCoverUrl,
                      width: 42,
                      height: 56,
                      borderRadius: 8,
                    ),
                    title: Text(
                      u.novelTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      u.chapterName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: u.dateUpload == null
                        ? null
                        : Text(
                            '${u.dateUpload}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: NovonColors.textTertiary),
                          ),
                    onTap: () => context.push(
                      RouterConstants.novelDetail(u.sourceId, u.novelUrl),
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
                    NovonColors.info.withValues(alpha: 0.15),
                    NovonColors.primary.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.update_rounded,
                color: NovonColors.info,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No new updates',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: NovonColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'New chapters from your library\nwill appear here',
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
}
