import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/providers/source_provider.dart';
import '../controllers/novel_detail_controller.dart';

/// Renders the chapter count and sorting/filtering options.
class NovelChapterListHeader extends ConsumerWidget {
  final List<SourceChapter> resolvedChapters;
  final AsyncValue<List<SourceChapter>> chapters;
  final String novelUrl;
  final bool ascending;
  final ValueChanged<bool> onSortToggled;

  const NovelChapterListHeader({
    super.key,
    required this.resolvedChapters,
    required this.chapters,
    required this.novelUrl,
    required this.ascending,
    required this.onSortToggled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (resolvedChapters.isEmpty && chapters.isLoading)
                ? Container(
                    width: 110,
                    height: 14,
                    decoration: BoxDecoration(
                      color: NovonColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  )
                : Text(
                    '${resolvedChapters.length} Chapters',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list_rounded, size: 20),
                  onPressed: () {},
                  color: NovonColors.textSecondary,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.sort_rounded, size: 20),
                  onPressed: () async {
                    final newVal = !ascending;
                    onSortToggled(newVal);
                    await ref
                        .read(novelDetailControllerProvider)
                        .persistChapterSortPreference(novelUrl, newVal);
                  },
                  color: NovonColors.textSecondary,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
