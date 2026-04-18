import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/widgets/novel_cover_image.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../../../core/providers/source_provider.dart';
import 'package:novon/core/common/constants/router_constants.dart';

/// Facilitates targeted content discovery within a specific extension-based 
/// content source, providing an orchestration interface for keyword-driven searches.
class SourceSearchScreen extends ConsumerStatefulWidget {
  final String sourceId;

  const SourceSearchScreen({super.key, required this.sourceId});

  @override
  ConsumerState<SourceSearchScreen> createState() => _SourceSearchScreenState();
}

class _SourceSearchScreenState extends ConsumerState<SourceSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = _query.trim().isEmpty
        ? null
        : ref.watch(
            sourceSearchProvider((
              sourceId: widget.sourceId,
              query: _query.trim(),
            )),
          );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search ${widget.sourceId}...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: NovonColors.textTertiary),
          ),
          onSubmitted: (query) => setState(() => _query = query),
        ),
      ),
      body: resultsAsync == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: NovonColors.textTertiary,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter a search term',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NovonColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : resultsAsync.when(
              loading: () => const NovelGridShimmer(
                itemCount: 9,
                padding: EdgeInsets.all(12),
                childAspectRatio: 0.47,
              ),
              error: (e, st) => Center(
                child: Text(
                  'Search failed: $e',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: NovonColors.error),
                ),
              ),
              data: (novels) {
                if (novels.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: NovonColors.textTertiary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No novels found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try a different keyword or shorter query.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: NovonColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.47,
                  ),
                  itemCount: novels.length,
                  itemBuilder: (context, index) {
                    final n = novels[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => context.push(
                        RouterConstants.novelDetail(
                          widget.sourceId,
                          n.url,
                          title: n.title,
                          coverUrl: n.coverUrl,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 3 / 5,
                            child: NovelCoverImage(
                              imageUrl: n.coverUrl,
                              borderRadius: 10,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            n.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
