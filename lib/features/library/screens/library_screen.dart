import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../../../core/common/widgets/error_view.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/common/models/chapter.dart' as m;
import '../../../core/common/models/novel.dart' as n;
import '../widgets/library_empty_state.dart';
import '../widgets/library_grid_item.dart';
import '../widgets/library_list_item.dart';
import '../widgets/library_filter_sheet.dart';
import '../providers/library_filter_provider.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import 'package:novon/core/common/constants/router_constants.dart';

/// Primary coordination surface for the user's personal collection management,
/// orchestrating novel categorization, discovery integration, and
/// consumption progress tracking.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _isGridView = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final library = ref.watch(libraryNovelsAggregatedProvider);
    final filterState = ref.watch(libraryFilterProvider);
    
    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search library...',
                      border: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() {}),
                  )
                : const Text('Library'),
            actions: [
              if (_isSearching)
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                    });
                  },
                )
              else ...[
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => setState(() => _isSearching = true),
                ),
                IconButton(
                  icon: Icon(
                    _isGridView
                        ? Icons.view_list_rounded
                        : Icons.grid_view_rounded,
                  ),
                  onPressed: () {
                    setState(() => _isGridView = !_isGridView);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list_rounded),
                  onPressed: () => _showFilterSheet(context),
                ),
              ],
            ],
          ),
          CupertinoSliverRefreshControl(onRefresh: _refreshLibraryFromSources),
          library.when(
            loading: () => const SliverFillRemaining(
              hasScrollBody: true,
              child: NovelGridShimmer(),
            ),
            error: (e, st) => SliverFillRemaining(
              hasScrollBody: false,
              child: ErrorView(
                message: 'Oops, something went wrong!',
                details: 'We encountered an issue loading your library.',
                onRetry: () => ref.invalidate(libraryNovelsAggregatedProvider),
              ),
            ),
            data: (rawNovels) {
              var novels = rawNovels.where((n) {
                if (_isSearching && _searchController.text.trim().isNotEmpty) {
                  final query = _searchController.text.trim().toLowerCase();
                  final titleMatch = n.title.toLowerCase().contains(query);
                  final authorMatch = n.author.toLowerCase().contains(query);
                  if (!titleMatch && !authorMatch) {
                    return false;
                  }
                }

                if (filterState.activeFilters.isEmpty) return true;
                bool matches = true;
                if (filterState.activeFilters.contains('Downloaded')) {
                  matches = matches && n.downloadedChapters > 0;
                }
                if (filterState.activeFilters.contains('Unread')) {
                  matches = matches && (n.totalChapters - n.readChapters) > 0;
                }
                if (filterState.activeFilters.contains('Started')) {
                  matches = matches && n.readChapters > 0 && n.readChapters < n.totalChapters;
                }
                if (filterState.activeFilters.contains('Completed')) {
                  matches = matches && n.readChapters == n.totalChapters && n.totalChapters > 0;
                }
                return matches;
              }).toList();

              novels.sort((a, b) {
                int cmp = 0;
                switch (filterState.sortMode) {
                  case LibrarySortMode.alphabetical:
                    cmp = a.title.toLowerCase().compareTo(b.title.toLowerCase());
                    break;
                  case LibrarySortMode.lastRead:
                    cmp = (a.lastRead ?? DateTime(1970)).compareTo(b.lastRead ?? DateTime(1970));
                    break;
                  case LibrarySortMode.lastUpdated:
                    cmp = (a.lastFetched ?? DateTime(1970)).compareTo(b.lastFetched ?? DateTime(1970));
                    break;
                  case LibrarySortMode.dateAdded:
                    cmp = (a.dateAdded ?? DateTime(1970)).compareTo(b.dateAdded ?? DateTime(1970));
                    break;
                  case LibrarySortMode.totalChapters:
                    cmp = a.totalChapters.compareTo(b.totalChapters);
                    break;
                  case LibrarySortMode.unread:
                    cmp = (a.totalChapters - a.readChapters).compareTo(b.totalChapters - b.readChapters);
                    break;
                }
                return filterState.ascending ? cmp : -cmp;
              });

              if (novels.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: LibraryEmptyState(),
                );
              }

              if (_isGridView) {
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final n = novels[index];
                      return LibraryGridItem(
                        novel: n,
                        onTap: () => context.push(
                          RouterConstants.novelDetail(n.sourceId, n.url),
                        ),
                      );
                    }, childCount: novels.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.47,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 16,
                        ),
                  ),
                );
              }

              return SliverList.separated(
                itemCount: novels.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final n = novels[index];
                  return LibraryListItem(
                    novel: n,
                    onTap: () => context.push(
                      RouterConstants.novelDetail(n.sourceId, n.url),
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

  /// Orchestrates a bulk background synchronization flow to apprise library
  /// entities of remote metadata updates and discover new content segments.
  Future<void> _refreshLibraryFromSources() async {
    final novels = await ref.read(libraryNovelsAggregatedProvider.future);
    final novelRepo = ref.read(novelRepositoryProvider);
    final chapterRepo = ref.read(chapterRepositoryProvider);
    final box = Hive.box(HiveBox.app);
    final rawPending = box.get(HiveKeys.notifChapterUpdates);
    final pending = rawPending is List
        ? rawPending.map((e) => e.toString()).toSet()
        : <String>{};

    await Future.wait(
      novels.map((libNovel) async {
        try {
          final detailFuture = ref.read(
            sourceNovelDetailProvider((
              sourceId: libNovel.sourceId,
              novelUrl: libNovel.url,
            )).future,
          );
          final chaptersFuture = ref.read(
            sourceChapterListProvider((
              sourceId: libNovel.sourceId,
              novelUrl: libNovel.url,
            )).future,
          );
          final detail = await detailFuture;
          final fetchedChapters = await chaptersFuture;

          await novelRepo.updateNovel(
            n.Novel(
              id: libNovel.id,
              sourceId: libNovel.sourceId,
              url: libNovel.url,
              title: detail.title.isEmpty ? libNovel.title : detail.title,
              author: detail.author ?? libNovel.author,
              description: detail.description ?? libNovel.description,
              coverUrl: (detail.coverUrl ?? '').isEmpty
                  ? libNovel.coverUrl
                  : detail.coverUrl!,
              status: libNovel.status,
              genres: detail.genres.isEmpty ? libNovel.genres : detail.genres,
              inLibrary: true,
              lastFetched: DateTime.now(),
            ),
          );

          final existing = await chapterRepo.getChaptersForNovel(libNovel.id);
          final existingById = {for (final c in existing) c.id: c};
          final newChapterIds = <String>{};
          final toInsert = fetchedChapters.map((ch) {
            final old = existingById[ch.url];
            if (old == null) {
              newChapterIds.add(ch.url);
            }
            return m.Chapter(
              id: ch.url,
              novelId: libNovel.id,
              url: ch.url,
              name: ch.name,
              number: (ch.number ?? -1).toDouble(),
              read: old?.read ?? false,
              downloaded: old?.downloaded ?? false,
              lastPageRead: old?.lastPageRead ?? 0,
            );
          }).toList();
          await chapterRepo.insertChapters(toInsert);
          pending.addAll(newChapterIds);
        } catch (_) {
          // Skip this novel refresh and keep old data as-is.
        }
      }),
    );
    await box.put(
      HiveKeys.notifChapterUpdates,
      pending.toList(growable: false),
    );
    ref.read(updatesSeenRevisionProvider.notifier).state++;
    ref.invalidate(updatesItemsProvider);
    ref.invalidate(unreadUpdatesCountProvider);
  }

  /// Orchestrates the invocation of the modal configuration surface for
  /// applying categorical filters and sorting appraisals to the library.
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const LibraryFilterSheet(),
    );
  }
}
