import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/novon_colors.dart';
import '../providers/library_filter_provider.dart';

/// Modal configuration surface responsible for orchestrating library-specific
/// sorting algorithms and categorical search appraisals.
class LibraryFilterSheet extends ConsumerWidget {
  const LibraryFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(libraryFilterProvider);
    final filterNotifier = ref.read(libraryFilterProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: NovonColors.textTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Filter & Sort',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort by',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: NovonColors.textSecondary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => filterNotifier.toggleAscending(),
                    icon: Icon(
                      filterState.ascending
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 16,
                    ),
                    label: Text(filterState.ascending ? 'Ascending' : 'Descending'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _sortChip('Alphabetical', LibrarySortMode.alphabetical, filterState, filterNotifier),
                  _sortChip('Last Read', LibrarySortMode.lastRead, filterState, filterNotifier),
                  _sortChip('Last Updated', LibrarySortMode.lastUpdated, filterState, filterNotifier),
                  _sortChip('Date Added', LibrarySortMode.dateAdded, filterState, filterNotifier),
                  _sortChip('Total Chapters', LibrarySortMode.totalChapters, filterState, filterNotifier),
                  _sortChip('Unread', LibrarySortMode.unread, filterState, filterNotifier),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Filter',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: NovonColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _filterChip('Downloaded', filterState, filterNotifier),
                  _filterChip('Unread', filterState, filterNotifier),
                  _filterChip('Started', filterState, filterNotifier),
                  _filterChip('Completed', filterState, filterNotifier),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sortChip(
    String label,
    LibrarySortMode mode,
    LibraryFilterState state,
    LibraryFilterNotifier notifier,
  ) {
    final selected = state.sortMode == mode;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => notifier.setSortMode(mode),
      selectedColor: NovonColors.primary.withValues(alpha: 0.2),
      checkmarkColor: NovonColors.primary,
      labelStyle: TextStyle(
        color: selected ? NovonColors.primary : NovonColors.textSecondary,
        fontSize: 12,
      ),
    );
  }

  Widget _filterChip(
    String label,
    LibraryFilterState state,
    LibraryFilterNotifier notifier,
  ) {
    final selected = state.activeFilters.contains(label);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => notifier.toggleFilter(label),
      selectedColor: NovonColors.primary.withValues(alpha: 0.2),
      checkmarkColor: NovonColors.primary,
      labelStyle: TextStyle(
        color: selected ? NovonColors.primary : NovonColors.textSecondary,
        fontSize: 12,
      ),
    );
  }
}

