import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/statistics_overview_tab.dart';
import '../widgets/statistics_time_tab.dart';
import '../widgets/statistics_novels_tab.dart';
import '../widgets/statistics_chapters_tab.dart';

/// A comprehensive analytics dashboard providing multi-dimensional insights 
/// into user consumption habits, including temporal patterns and volume metrics.
class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Text('Export Statistics'),
              ),
              PopupMenuItem(
                value: 'reset',
                child: Text(
                  'Reset Statistics',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCustomTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                StatisticsOverviewTab(),
                StatisticsTimeTab(),
                StatisticsNovelsTab(),
                StatisticsChaptersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    final tabs = ['Overview', 'Time', 'Novels', 'Chapters'];
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = _tabController.index == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _tabController.animateTo(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
