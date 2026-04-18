import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:novon/core/common/enums/library_sort_mode.dart';
export 'package:novon/core/common/enums/library_sort_mode.dart';
import '../../../core/common/constants/hive_constants.dart';

class LibraryFilterState {
  final LibrarySortMode sortMode;
  final bool ascending;
  final Set<String>
  activeFilters; // 'Downloaded', 'Unread', 'Started', 'Completed'

  const LibraryFilterState({
    this.sortMode = LibrarySortMode.lastUpdated,
    this.ascending = false,
    this.activeFilters = const {},
  });

  LibraryFilterState copyWith({
    LibrarySortMode? sortMode,
    bool? ascending,
    Set<String>? activeFilters,
  }) {
    return LibraryFilterState(
      sortMode: sortMode ?? this.sortMode,
      ascending: ascending ?? this.ascending,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

class LibraryFilterNotifier extends StateNotifier<LibraryFilterState> {
  LibraryFilterNotifier() : super(const LibraryFilterState()) {
    _loadFromHive();
  }

  void _loadFromHive() {
    final box = Hive.box(HiveBox.app);
    final rawSort =
        box.get(HiveKeys.librarySort, defaultValue: 'lastUpdated') as String;
    final sortMode = LibrarySortMode.values.firstWhere(
      (e) => e.name == rawSort,
      orElse: () => LibrarySortMode.lastUpdated,
    );
    final ascending =
        box.get(HiveKeys.libraryAscending, defaultValue: false) as bool;
    final rawFilters = box.get(
      HiveKeys.libraryFilters,
      defaultValue: <String>[],
    );
    final activeFilters = (rawFilters as List).map((e) => e.toString()).toSet();

    state = LibraryFilterState(
      sortMode: sortMode,
      ascending: ascending,
      activeFilters: activeFilters,
    );
  }

  Future<void> _saveToHive() async {
    final box = Hive.box(HiveBox.app);
    await box.put(HiveKeys.librarySort, state.sortMode.name);
    await box.put(HiveKeys.libraryAscending, state.ascending);
    await box.put(HiveKeys.libraryFilters, state.activeFilters.toList());
  }

  void setSortMode(LibrarySortMode mode) {
    if (state.sortMode == mode) {
      state = state.copyWith(ascending: !state.ascending);
    } else {
      state = state.copyWith(sortMode: mode, ascending: false);
    }
    _saveToHive();
  }

  void toggleAscending() {
    state = state.copyWith(ascending: !state.ascending);
    _saveToHive();
  }

  void toggleFilter(String filter) {
    final newFilters = Set<String>.from(state.activeFilters);
    if (newFilters.contains(filter)) {
      newFilters.remove(filter);
    } else {
      newFilters.add(filter);
    }
    state = state.copyWith(activeFilters: newFilters);
    _saveToHive();
  }
}

final libraryFilterProvider =
    StateNotifierProvider<LibraryFilterNotifier, LibraryFilterState>((ref) {
      return LibraryFilterNotifier();
    });
