import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/enums/chapter_download_status.dart';
import '../../../core/providers/download_provider.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import '../controllers/novel_detail_controller.dart';

/// Renders the contextual download interactive element for a specific chapter,
/// resolving real-time streaming state and deterministic downloaded status.
class NovelChapterDownloadButton extends ConsumerWidget {
  final String chapterUrl;
  final String chapterName;
  final String sourceId;
  final String novelUrl;
  final Set<String> downloadedState;
  final NovelDetailController controller;

  const NovelChapterDownloadButton({
    super.key,
    required this.chapterUrl,
    required this.chapterName,
    required this.sourceId,
    required this.novelUrl,
    required this.downloadedState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(chapterDownloadInfoProvider(chapterUrl));
    if (controller.containsNormalized(downloadedState, chapterUrl) ||
        info?.status == ChapterDownloadStatus.complete) {
      return Icon(Icons.download_done_rounded, color: NovonColors.success);
    }
    if (info?.status == ChapterDownloadStatus.downloading ||
        info?.status == ChapterDownloadStatus.queued) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: ShimmerLoading(width: 22, height: 22, borderRadius: 999),
      );
    }
    if (info?.status == ChapterDownloadStatus.failed) {
      return Icon(Icons.error_outline_rounded, color: NovonColors.error);
    }
    return IconButton(
      tooltip: 'Download chapter',
      icon: const Icon(Icons.download_for_offline_rounded),
      onPressed: () async {
        await ref
            .read(chapterDownloadControllerProvider.notifier)
            .enqueueChapter(
              sourceId: sourceId,
              novelId: novelUrl,
              chapterId: chapterUrl,
              chapterName: chapterName,
              chapterUrl: chapterUrl,
            );
      },
    );
  }
}
