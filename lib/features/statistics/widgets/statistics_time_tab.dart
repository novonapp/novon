import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/widgets/error_view.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../providers/statistics_provider.dart';

class StatisticsTimeTab extends ConsumerWidget {
  const StatisticsTimeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(statisticsOverviewProvider);
    final dailyAsync = ref.watch(statisticsDailyReadingProvider(30));

    // Combine both async values for unified loading state
    if (overviewAsync.isLoading || dailyAsync.isLoading) {
      return const StatsGridShimmer();
    }

    if (overviewAsync.hasError) {
      log(
        'Time Tab Overview Error',
        error: overviewAsync.error,
        stackTrace: overviewAsync.stackTrace,
      );
      return ErrorView(
        message: 'Failed to load statistics',
        details: overviewAsync.error.toString(),
      );
    }

    if (dailyAsync.hasError) {
      log(
        'Time Tab Daily Reading Error',
        error: dailyAsync.error,
        stackTrace: dailyAsync.stackTrace,
      );
      return ErrorView(
        message: 'Failed to load daily reading data',
        details: dailyAsync.error.toString(),
      );
    }

    final overview = overviewAsync.value!;
    final dailyStats = dailyAsync.value!;

    final lifetimeMinutes = overview.totalTimeSpentMs ~/ 60000;
    final hours = lifetimeMinutes ~/ 60;
    final minutes = lifetimeMinutes % 60;

    final today = DateTime.now();
    List<BarChartGroupData> barGroups = [];
    double maxHours = 1.0;

    for (int i = 29; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final match = dailyStats.where(
        (s) =>
            s.date.year == day.year &&
            s.date.month == day.month &&
            s.date.day == day.day,
      );
      final ms = match.isNotEmpty ? match.first.timeSpentMs : 0;
      final hrs = ms / 3600000.0;
      if (hrs > maxHours) maxHours = hrs;

      barGroups.add(
        BarChartGroupData(
          x: 29 - i,
          barRods: [
            BarChartRodData(
              toY: hrs,
              color: Theme.of(context).colorScheme.primary,
              width: 6,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxHours,
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      );
    }

    // Add some padding to maxY so bars don't touch the very top
    maxHours = (maxHours * 1.2).ceilToDouble();
    if (maxHours == 0) maxHours = 5;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.access_time_filled,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                '${hours}h ${minutes}m',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lifetime reading time',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 24.0),
          child: Text(
            'Daily Reading (Last 30 Days)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Container(
          height: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: BarChart(
            BarChartData(
              maxY: maxHours,
              barGroups: barGroups,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxHours / 4,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.2),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: maxHours / 4,
                    getTitlesWidget: (v, meta) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '${v.toInt()}h',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 7,
                    getTitlesWidget: (v, meta) {
                      final day = today.subtract(
                        Duration(days: 29 - v.toInt()),
                      );
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${day.month}/${day.day}',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
