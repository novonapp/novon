import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import '../../../core/providers/source_provider.dart';
import '../../../core/services/storage_path_service.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/common/models/chapter.dart' as mc;
import '../../../core/services/novel_metadata_service.dart';
import '../../../core/services/extension_engine.dart';
import '../../../core/common/constants/router_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/common/constants/hive_constants.dart';

import '../widgets/novel_detail_header.dart';
import '../widgets/novel_description_section.dart';
import '../widgets/novel_genre_chips.dart';
import '../widgets/novel_action_bar.dart';
import '../widgets/novel_chapter_list_header.dart';
import '../widgets/novel_chapter_list.dart';
import '../widgets/novel_reading_fab.dart';
import '../controllers/novel_detail_controller.dart';

/// Provides a comprehensive detail view comprising metadata orchestration,
/// chapter indexing, and administrative lifecycle management for a specific novel.
class NovelDetailScreen extends ConsumerStatefulWidget {
  final String sourceId;
  final String novelId;
  final String? initialTitle;
  final String? initialCoverUrl;

  const NovelDetailScreen({
    super.key,
    required this.sourceId,
    required this.novelId,
    this.initialTitle,
    this.initialCoverUrl,
  });

  @override
  ConsumerState<NovelDetailScreen> createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends ConsumerState<NovelDetailScreen> {
  bool _ascending = false;
  int _lastPersistSignature = 0;
  bool _descriptionExpanded = false;
  String? _pickedCoverUrl;
  final ScrollController _chapterScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final novelUrl = Uri.decodeComponent(widget.novelId);
      final asc = await ref
          .read(novelDetailControllerProvider)
          .loadChapterSortPreference(novelUrl);
      if (mounted) setState(() => _ascending = asc);

      // Kick off the background metadata + chapter refresh silently.
      _refreshInBackground(novelUrl);
    });
  }

  @override
  void dispose() {
    _chapterScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final novelUrl = Uri.decodeComponent(widget.novelId);

    final cachedNovel = ref
        .watch(cachedNovelDetailProvider(novelUrl))
        .valueOrNull;
    final cachedChaptersAsync = ref.watch(
      cachedNovelChaptersProvider(novelUrl),
    );
    final cachedChapters =
        (cachedChaptersAsync.valueOrNull ?? const <mc.Chapter>[])
            .map(
              (c) => SourceChapter(
                name: c.name,
                url: c.url,
                number: c.number >= 0 ? c.number : null,
              ),
            )
            .toList(growable: false);

    final isLibraryNovel = cachedNovel?.inLibrary == true;

    final liveDetail = ref.watch(
      sourceNovelDetailProvider((
        sourceId: widget.sourceId,
        novelUrl: novelUrl,
      )),
    );

    final AsyncValue<SourceNovelDetail> detail;
    if (isLibraryNovel && cachedNovel != null) {
      detail = AsyncData(
        SourceNovelDetail(
          title: cachedNovel.title,
          author: cachedNovel.author.isEmpty ? null : cachedNovel.author,
          description: cachedNovel.description.isEmpty
              ? null
              : cachedNovel.description,
          status: cachedNovel.status.name,
          genres: cachedNovel.genres,
          coverUrl: cachedNovel.coverUrl.isEmpty ? null : cachedNovel.coverUrl,
        ),
      );
    } else {
      detail = liveDetail;
    }

    final chapters = isLibraryNovel
        ? ref.watch(
            sourceChapterListProvider((
              sourceId: widget.sourceId,
              novelUrl: novelUrl,
            )),
          )
        : ref.watch(
            sourceChapterListProvider((
              sourceId: widget.sourceId,
              novelUrl: novelUrl,
            )),
          );

    final resolvedChapters = cachedChapters.isNotEmpty
        ? cachedChapters
        : (chapters.valueOrNull ?? const <SourceChapter>[]);

    final remoteChapters = chapters.valueOrNull ?? const <SourceChapter>[];
    if (remoteChapters.isNotEmpty) {
      final signature = Object.hash(
        remoteChapters.length,
        remoteChapters.first.url,
        remoteChapters.last.url,
      );
      if (signature != _lastPersistSignature) {
        _lastPersistSignature = signature;
        Future.microtask(
          () => ref
              .read(novelDetailControllerProvider)
              .persistFetchedChapters(novelUrl, remoteChapters),
        );
      }
    }

    final inLibrary = ref.watch(isNovelInLibraryStreamProvider(novelUrl));
    final readStateAsync = ref.watch(chapterReadStateProvider(novelUrl));
    final readState = readStateAsync.valueOrNull ?? const <String>{};
    final downloadedStateAsync = ref.watch(
      chapterDownloadedStateProvider(novelUrl),
    );
    final downloadedState =
        downloadedStateAsync.valueOrNull ?? const <String>{};

    final box = Hive.box(HiveBox.app);
    final lastRaw = box.get(HiveKeys.novelLastChapter);
    final lastMap = lastRaw is Map
        ? Map<String, dynamic>.from(lastRaw)
        : <String, dynamic>{};
    final lastChapterUrl = (lastMap['${widget.sourceId}|$novelUrl'] ?? '')
        .toString();

    final cachedCoverUrl = cachedNovel?.coverUrl.trim();
    final detailCover = detail.valueOrNull?.coverUrl?.trim();
    final initialCover = widget.initialCoverUrl?.trim();
    final pickedCover = _pickedCoverUrl?.trim();
    final headerCoverUrl = (pickedCover != null && pickedCover.isNotEmpty)
        ? pickedCover
        : (cachedCoverUrl != null && cachedCoverUrl.isNotEmpty)
        ? cachedCoverUrl
        : ((detailCover != null && detailCover.isNotEmpty)
              ? detailCover
              : initialCover);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _forceRefreshAll(novelUrl);
        },
        child: Scrollbar(
          controller: _chapterScrollController,
          thumbVisibility: true,
          interactive: true,
          thickness: 4,
          radius: const Radius.circular(999),
          child: CustomScrollView(
            controller: _chapterScrollController,
            slivers: [
              NovelDetailHeader(
                detail: detail,
                headerCoverUrl: headerCoverUrl,
                initialTitle: widget.initialTitle,
                sourceId: widget.sourceId,
                onWebView: () => _openWebView(novelUrl),
              ),

              NovelActionBar(
                detail: detail,
                chapters: chapters,
                inLibrary: inLibrary,
                novelUrl: novelUrl,
                sourceId: widget.sourceId,
                readState: readState,
                downloadedState: downloadedState,
                initialTitle: widget.initialTitle,
                initialCoverUrl: widget.initialCoverUrl,
              ),

              NovelDescriptionSection(
                detail: detail,
                expanded: _descriptionExpanded,
                onToggle: () => setState(
                  () => _descriptionExpanded = !_descriptionExpanded,
                ),
              ),

              NovelGenreChips(detail: detail),

              NovelChapterListHeader(
                resolvedChapters: resolvedChapters,
                chapters: chapters,
                novelUrl: novelUrl,
                ascending: _ascending,
                onSortToggled: (asc) => setState(() => _ascending = asc),
              ),

              NovelChapterList(
                resolvedChapters: resolvedChapters,
                chapters: chapters,
                novelUrl: novelUrl,
                sourceId: widget.sourceId,
                ascending: _ascending,
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
      floatingActionButton: NovelReadingFab(
        resolvedChapters: resolvedChapters,
        lastChapterUrl: lastChapterUrl,
        novelUrl: novelUrl,
        sourceId: widget.sourceId,
        ascending: _ascending,
      ),
    );
  }

  void _refreshInBackground(String novelUrl) {
    Future.microtask(() async {
      final novelRepo = ref.read(novelRepositoryProvider);
      final chapterRepo = ref.read(chapterRepositoryProvider);
      final sps = StoragePathService.instance;
      final storagePath = sps.storagePath;
      if (storagePath == null) return;

      final cached = await novelRepo.getNovelById(novelUrl);
      if (cached == null || !cached.inLibrary) return;

      final sourceFile = File(
        '$storagePath/extensions/${widget.sourceId}/source.js',
      );
      if (!await sourceFile.exists()) return;
      final scriptSource = await sourceFile.readAsString();
      final engine = ExtensionEngine.instance;

      Map<String, dynamic> freshDetail = {};
      List<dynamic> freshChapters = [];

      await Future.wait([
        () async {
          try {
            final raw = await engine.fetchNovelDetail(
              widget.sourceId,
              scriptSource,
              novelUrl,
            );
            freshDetail = Map<String, dynamic>.from(raw as Map);
          } catch (_) {}
        }(),
        () async {
          try {
            final raw = await engine.fetchChapterList(
              widget.sourceId,
              scriptSource,
              novelUrl,
            );
            freshChapters = List<dynamic>.from(raw as List);
          } catch (_) {}
        }(),
      ]);

      await NovelMetadataService.instance.refreshIfInLibrary(
        novelUrl: novelUrl,
        novelRepo: novelRepo,
        chapterRepo: chapterRepo,
        freshDetail: freshDetail,
        freshChapters: freshChapters,
      );
    });
  }

  Future<void> _forceRefreshAll(String novelUrl) async {
    final novelRepo = ref.read(novelRepositoryProvider);
    final chapterRepo = ref.read(chapterRepositoryProvider);
    final sps = StoragePathService.instance;
    final storagePath = sps.storagePath;
    if (storagePath == null) return;

    final sourceFile = File(
      '$storagePath/extensions/${widget.sourceId}/source.js',
    );
    if (!await sourceFile.exists()) return;
    final scriptSource = await sourceFile.readAsString();
    final engine = ExtensionEngine.instance;

    Map<String, dynamic> freshDetail = {};
    List<dynamic> freshChapters = [];

    await Future.wait([
      () async {
        try {
          final raw = await engine.fetchNovelDetail(
            widget.sourceId,
            scriptSource,
            novelUrl,
          );
          freshDetail = Map<String, dynamic>.from(raw as Map);
        } catch (_) {}
      }(),
      () async {
        try {
          final raw = await engine.fetchChapterList(
            widget.sourceId,
            scriptSource,
            novelUrl,
          );
          freshChapters = List<dynamic>.from(raw as List);
        } catch (_) {}
      }(),
    ]);

    await NovelMetadataService.instance.refreshIfInLibrary(
      novelUrl: novelUrl,
      novelRepo: novelRepo,
      chapterRepo: chapterRepo,
      freshDetail: freshDetail,
      freshChapters: freshChapters,
    );
  }

  Future<void> _openWebView(String novelUrl) async {
    final storagePath = StoragePathService.instance.storagePath;
    if (storagePath == null) return;
    final manifestFile = File(
      '$storagePath/extensions/${widget.sourceId}/manifest.json',
    );
    if (!await manifestFile.exists()) return;
    if (!mounted) return;
    final picked = await context.push<String>(
      RouterConstants.cookieWebview(novelUrl, widget.sourceId),
    );
    if (picked != null && picked.trim().isNotEmpty && mounted) {
      final selectedCover = picked.trim();
      setState(() => _pickedCoverUrl = selectedCover);
      final repo = ref.read(novelRepositoryProvider);
      final existing = await repo.getNovel(widget.sourceId, widget.novelId);
      if (existing != null) {
        await repo.updateNovel(existing.copyWith(coverUrl: selectedCover));
      }
    }
  }
}
