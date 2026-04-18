import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../../../core/common/widgets/error_view.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/extension_provider.dart';
import 'package:novon/core/common/models/novel.dart' as m;
import 'package:novon/core/common/constants/hive_constants.dart';
import 'package:novon/core/common/constants/router_constants.dart';

/// Orchestration interface for the paginated discovery of remote novel
/// catalogs from a specific content source extension.
class SourceBrowseScreen extends ConsumerStatefulWidget {
  final String sourceId;

  const SourceBrowseScreen({super.key, required this.sourceId});

  @override
  ConsumerState<SourceBrowseScreen> createState() => _SourceBrowseScreenState();
}

class _SourceBrowseScreenState extends ConsumerState<SourceBrowseScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    log(
      '=== SourceBrowseScreen: Initiated for source ID: ${widget.sourceId} ===',
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    log(
      '=== SourceBrowseScreen: Disposed for source ID: ${widget.sourceId} ===',
    );
    super.dispose();
  }

  /// Appraises the current scroll positioning to trigger greedy pagination
  /// when the client approaches the viewport threshold.
  void _onScroll() {
    if (!_scrollController.hasClients || _isLoadingMore) return;
    final pos = _scrollController.position;
    final ratio = pos.maxScrollExtent <= 0
        ? 0.0
        : (pos.pixels / pos.maxScrollExtent);
    if (ratio >= 0.60) {
      _loadMore();
    }
  }

  /// Orchestrates the asynchronous retrieval of the next collection of
  /// novel results from the remote content source.
  Future<void> _loadMore() async {
    final current = ref.read(sourceLatestProvider(widget.sourceId));
    final hasNext = current.valueOrNull?.hasNextPage ?? false;
    if (!hasNext) return;
    _isLoadingMore = true;
    try {
      await ref.read(sourceLatestProvider(widget.sourceId).notifier).loadMore();
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Purges localized HTML and metadata caches associated with the current
  /// content source to ensure data freshness upon subsequent resolution.
  Future<void> _clearSourceCache() async {
    final box = Hive.box(HiveBox.app);
    final raw = box.get(HiveKeys.chapterHtmlCache);
    final map = raw is Map
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};
    map.removeWhere(
      (key, _) => key.toString().startsWith('${widget.sourceId}|'),
    );
    await box.put(HiveKeys.chapterHtmlCache, map);

    ref.invalidate(sourceLatestProvider(widget.sourceId));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Source cache cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final latest = ref.watch(sourceLatestProvider(widget.sourceId));
    final installed = ref.watch(installedExtensionsProvider);
    final sourceManifest = installed.whenOrNull(
      data: (list) {
        for (final m in list) {
          if (m.id == widget.sourceId) return m;
        }
        return null;
      },
    );
    final sourceName =
        installed.whenOrNull(
          data: (list) {
            for (final m in list) {
              if (m.id == widget.sourceId) return m.name;
            }
            return widget.sourceId;
          },
        ) ??
        widget.sourceId;

    return Scaffold(
      appBar: AppBar(
        title: Text(sourceName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              context.push(RouterConstants.sourceSearch(widget.sourceId));
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) async {
              if (value == 'clear_cache') {
                await _clearSourceCache();
              } else if (value == 'open_webview') {
                if (!mounted) return;
                await context.push(
                  RouterConstants.cookieWebview(
                    sourceManifest?.baseUrl ?? 'https://',
                    widget.sourceId,
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'clear_cache', child: Text('Clear cache')),
              PopupMenuItem(value: 'open_webview', child: Text('Open WebView')),
            ],
          ),
        ],
      ),
      body: latest.when(
        loading: () => const NovelGridShimmer(),
        error: (e, st) => ErrorView(
          message: 'Failed to load novels',
          details: e.toString(),
          onRetry: () => ref
              .read(sourceLatestProvider(widget.sourceId).notifier)
              .refresh(),
        ),
        data: (result) {
          if (result.novels.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref
                  .read(sourceLatestProvider(widget.sourceId).notifier)
                  .refresh(),
              child: ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('No novels found.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref
                .read(sourceLatestProvider(widget.sourceId).notifier)
                .refresh(),
            child: GridView.builder(
              controller: _scrollController,
              cacheExtent: 2800,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.47,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: result.hasNextPage
                  ? result.novels.length + 1
                  : result.novels.length,
              itemBuilder: (context, index) {
                if (index >= result.novels.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ShimmerLoading(
                        width: 20,
                        height: 20,
                        borderRadius: 999,
                      ),
                    ),
                  );
                }
                final novel = result.novels[index];
                return InkWell(
                  key: ValueKey(novel.url),
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    /// Proactively persists skeletal novel metadata (title, cover) in the
                    /// repository layer to ensure consistent visual state in the library
                    /// even if subsequent detailed metadata resolution fails.
                    await ref
                        .read(novelRepositoryProvider)
                        .insertNovel(
                          m.Novel(
                            id: novel.url,
                            sourceId: widget.sourceId,
                            url: novel.url,
                            title: novel.title,
                            coverUrl: novel.coverUrl,
                            inLibrary: false,
                            lastFetched: DateTime.now(),
                          ),
                        );
                    if (!context.mounted) return;
                    context.push(
                      RouterConstants.novelDetail(
                        widget.sourceId,
                        novel.url,
                        title: novel.title,
                        coverUrl: novel.coverUrl,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 3 / 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: novel.coverUrl,
                            cacheKey: novel.url,
                            useOldImageOnUrlChange: true,
                            fadeInDuration: Duration.zero,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const ShimmerLoading(
                              height: double.infinity,
                              borderRadius: 8,
                            ),
                            errorWidget: (context, url, err) => Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        novel.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
