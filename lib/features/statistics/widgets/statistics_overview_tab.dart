import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/widgets/error_view.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../providers/statistics_provider.dart';

class StatisticsOverviewTab extends ConsumerWidget {
  const StatisticsOverviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statisticsOverviewProvider);

    return statsAsync.when(
      data: (stats) {
        final hours = stats.totalTimeSpentMs ~/ 3600000;

        return GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            StatCard(
              icon: Icons.menu_book,
              value: stats.totalNovels.toString(),
              label: 'Total Novels',
            ),
            StatCard(
              icon: Icons.check_circle_outline,
              value: stats.completedNovels.toString(),
              label: 'Completed',
            ),
            StatCard(
              icon: Icons.timer,
              value: '${hours}h',
              label: 'Time Reading',
            ),
            StatCard(
              icon: Icons.local_fire_department,
              value: stats.currentStreak.toString(),
              label: 'Current Streak',
            ),
            StatCard(
              icon: Icons.text_snippet,
              value: stats.totalWordsRead.toString(),
              label: 'Words Read',
            ),
            StatCard(
              icon: Icons.speed,
              value: stats.avgWordsPerChapter.toString(),
              label: 'Words/Chap Avg',
            ),
          ],
        );
      },
      loading: () => const StatsGridShimmer(),
      error: (e, st) {
        log('Statistics Overview Error', error: e, stackTrace: st);
        return ErrorView(
          message: 'Failed to load statistics',
          details: e.toString(),
        );
      },
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 26),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
