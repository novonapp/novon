import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/widgets/error_view.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../providers/statistics_provider.dart';
import 'statistics_empty_state.dart';

class StatisticsNovelsTab extends StatelessWidget {
  const StatisticsNovelsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final topNovels = ref.watch(statisticsTopNovelsProvider);
        return topNovels.when(
          loading: () => const CoverListShimmer(),
          error: (e, st) => ErrorView(
              message: 'Failed to load novel statistics',
              details: e.toString()),
          data: (items) {
            if (items.isEmpty) {
              return buildStatisticsEmptyState(
                context,
                Icons.pie_chart_outline_rounded,
                'No Novel Statistics Yet',
                'Read some chapters to see top novels and activity.',
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
                  title: Text(it.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${it.chaptersRead} chapter reads'),
                  trailing:
                      Text('${(it.totalTimeSpentMs / 60000).round()}m'),
                );
              },
            );
          },
        );
      },
    );
  }
}
