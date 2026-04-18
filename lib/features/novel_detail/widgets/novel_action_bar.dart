import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/providers/source_provider.dart';
import '../controllers/novel_detail_controller.dart';
import 'novel_download_sheet.dart';

/// Provides primary contextual actions for a novel: Add to Library, Download, and Share.
class NovelActionBar extends ConsumerWidget {
  final AsyncValue<SourceNovelDetail> detail;
  final AsyncValue<List<SourceChapter>> chapters;
  final AsyncValue<bool> inLibrary;
  final String novelUrl;
  final String sourceId;
  final Set<String> readState;
  final Set<String> downloadedState;
  final String? initialTitle;
  final String? initialCoverUrl;

  const NovelActionBar({
    super.key,
    required this.detail,
    required this.chapters,
    required this.inLibrary,
    required this.novelUrl,
    required this.sourceId,
    required this.readState,
    required this.downloadedState,
    this.initialTitle,
    this.initialCoverUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => ref
                    .read(novelDetailControllerProvider)
                    .toggleLibrary(
                      context,
                      sourceId,
                      novelUrl,
                      detail,
                      inLibrary,
                      initialTitle: initialTitle,
                      initialCoverUrl: initialCoverUrl,
                    ),
                icon: Icon(
                  inLibrary.valueOrNull == true
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 18,
                ),
                label: Text(
                  inLibrary.valueOrNull == true
                      ? 'Remove from Library'
                      : 'Add to Library',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: NovonColors.primary,
                  foregroundColor: NovonColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: NovonColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => NovelDownloadSheet.show(
                  context,
                  ref,
                  chapters,
                  readState,
                  downloadedState,
                  novelUrl,
                  sourceId,
                  false, // ascending defaults to false unless passed differently
                ),
                icon: const Icon(Icons.download_rounded),
                color: NovonColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: NovonColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => ref
                    .read(novelDetailControllerProvider)
                    .shareNovel(detail, novelUrl),
                icon: const Icon(Icons.share_rounded),
                color: NovonColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
