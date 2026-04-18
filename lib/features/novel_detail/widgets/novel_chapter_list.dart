import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/common/constants/hive_constants.dart';
import '../../../core/common/constants/router_constants.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/providers/db_providers.dart';
import '../controllers/novel_detail_controller.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import 'novel_chapter_tile.dart';
import 'novel_chapter_download_button.dart';

/// Pre-computed and cached chapter list builder.
class NovelChapterList extends ConsumerStatefulWidget {
  final List<SourceChapter> resolvedChapters;
  final AsyncValue<List<SourceChapter>> chapters;
  final String novelUrl;
  final String sourceId;
  final bool ascending;

  const NovelChapterList({
    super.key,
    required this.resolvedChapters,
    required this.chapters,
    required this.novelUrl,
    required this.sourceId,
    required this.ascending,
  });

  @override
  ConsumerState<NovelChapterList> createState() => _NovelChapterListState();
}

class _NovelChapterListState extends ConsumerState<NovelChapterList> {
  List<SourceChapter> _sortedChaptersCache = const <SourceChapter>[];
  int _sortedChaptersCacheKey = 0;
  Map<String, bool> _readLookupCache = const <String, bool>{};
  Map<String, double> _progressLookupCache = const <String, double>{};

  @override
  Widget build(BuildContext context) {
    if (widget.resolvedChapters.isEmpty && widget.chapters.isLoading) {
      return const SliverToBoxAdapter(child: ChapterListShimmer(itemCount: 5));
    }

    final cacheKey = Object.hash(
      widget.resolvedChapters.length,
      widget.resolvedChapters.isNotEmpty
          ? widget.resolvedChapters.first.url
          : '',
      widget.resolvedChapters.isNotEmpty
          ? widget.resolvedChapters.last.url
          : '',
      widget.ascending,
    );
    if (cacheKey != _sortedChaptersCacheKey) {
      _sortedChaptersCacheKey = cacheKey;
      final sorted = [...widget.resolvedChapters];
      sorted.sort((a, b) {
        final an = a.number ?? -1;
        final bn = b.number ?? -1;
        return widget.ascending ? an.compareTo(bn) : bn.compareTo(an);
      });
      _sortedChaptersCache = sorted;
    }
    final sorted = _sortedChaptersCache;

    final controller = ref.read(novelDetailControllerProvider);
    final readStateAsync = ref.watch(chapterReadStateProvider(widget.novelUrl));
    final readState = readStateAsync.valueOrNull ?? const <String>{};
    final downloadedStateAsync = ref.watch(
      chapterDownloadedStateProvider(widget.novelUrl),
    );
    final downloadedState =
        downloadedStateAsync.valueOrNull ?? const <String>{};

    final box = Hive.box(HiveBox.app);
    final progressRaw = box.get(HiveKeys.chapterProgress);
    final allProgress = progressRaw is Map
        ? Map<String, dynamic>.from(progressRaw)
        : <String, dynamic>{};
    final novelProgressRaw =
        allProgress['${widget.sourceId}|${widget.novelUrl}'];
    final progressMap = novelProgressRaw is Map
        ? Map<String, dynamic>.from(novelProgressRaw)
        : <String, dynamic>{};

    _readLookupCache = controller.buildReadLookup(readState);
    _progressLookupCache = controller.buildProgressLookup(progressMap);

    return SliverList.builder(
      itemCount: sorted.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemBuilder: (context, i) {
        final ch = sorted[i];
        final isRead = controller.isChapterRead(_readLookupCache, ch.url);
        final pct = controller.progressFromLookup(_progressLookupCache, ch.url);
        return RepaintBoundary(
          child: NovelChapterTile(
            chapterName: ch.name,
            chapterUrl: ch.url,
            chapterNumber: ch.number ?? (num.parse("-1")),
            isRead: isRead,
            progressPercent: pct,
            onTap: () => _openChapter(
              ch.url,
              widget.novelUrl,
              downloadedState,
              controller,
            ),
            onSwipeDismiss: (_) =>
                controller.toggleChapterRead(context, ch.url, isRead),
            downloadTrailing: NovelChapterDownloadButton(
              chapterUrl: ch.url,
              chapterName: ch.name,
              sourceId: widget.sourceId,
              novelUrl: widget.novelUrl,
              downloadedState: downloadedState,
              controller: controller,
            ),
          ),
        );
      },
    );
  }

  Future<void> _openChapter(
    String chapterUrl,
    String novelUrl,
    Set<String> downloadedState,
    NovelDetailController controller,
  ) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!mounted) return;
    final isOffline = connectivity.contains(ConnectivityResult.none);
    final isDownloaded = controller.containsNormalized(
      downloadedState,
      chapterUrl,
    );
    if (isOffline && !isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chapter is not downloaded for offline reading'),
        ),
      );
      return;
    }
    final encodedNovelId = Uri.encodeComponent(novelUrl);
    final encodedChapterId = Uri.encodeComponent(chapterUrl);
    context.push(
      RouterConstants.reader(widget.sourceId, encodedNovelId, encodedChapterId),
    );
  }
}
