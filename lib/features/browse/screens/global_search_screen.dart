import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/novon_colors.dart';

/// Unified orchestration interface for executing concurrent discovery 
/// queries across the prioritized collection of installed content sources.
class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search across all sources...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: NovonColors.textTertiary,
                ),
          ),
          onSubmitted: (query) {},
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            ),
        ],
      ),
      body: Center(
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
                Icons.travel_explore_rounded,
                color: NovonColors.textTertiary,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Global Search',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: NovonColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search across all installed sources\nsimultaneously',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
