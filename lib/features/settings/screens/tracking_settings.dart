import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Configuration interface for orchestrating progress synchronization and
/// metadata reconciliation with third-party archival and tracking platforms.
class TrackingSettingsScreen extends ConsumerWidget {
  const TrackingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Connect your accounts to automatically sync reading progress, scores, and chapter status.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          _buildTrackerCard(
            context,
            'AniList',
            Icons.bar_chart_rounded,
            'Not connected',
          ),
          const SizedBox(height: 12),
          _buildTrackerCard(
            context,
            'MyAnimeList',
            Icons.list_alt_rounded,
            'Not connected',
          ),
          const SizedBox(height: 12),
          _buildTrackerCard(
            context,
            'NovelUpdates',
            Icons.update_rounded,
            'Not connected',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tracker OAuth integration is planned for a future release.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerCard(
    BuildContext context,
    String name,
    IconData icon,
    String status,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        status,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Connect $name'),
                    content: Text(
                      '$name OAuth integration is coming in a future update. '
                      'Stay tuned for tracker sync support.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => ctx.pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
