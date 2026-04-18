import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/widgets/error_view.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../providers/statistics_provider.dart';
import 'statistics_empty_state.dart';

class StatisticsChaptersTab extends StatelessWidget {
  const StatisticsChaptersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final topChapters = ref.watch(statisticsTopChaptersProvider);
        return topChapters.when(
          loading: () => const CoverListShimmer(),
          error: (e, st) => ErrorView(
              message: 'Failed to load chapter statistics',
              details: e.toString()),
          data: (items) {
            if (items.isEmpty) {
              return buildStatisticsEmptyState(
                context,
                Icons.timeline_rounded,
                'No Chapter Activity',
                'Read some chapters to populate this section.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final it = items[i];
                return ListTile(
                  leading: CircleAvatar(child: Text('${i + 1}')),
                  title: Text(it.chapterName,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(it.novelTitle,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text('x${it.readCount}'),
                );
              },
            );
          },
        );
      },
    );
  }
}
