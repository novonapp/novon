import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/source_provider.dart';
import '../controllers/novel_detail_controller.dart';
import '../../../core/providers/download_provider.dart';
import '../../../core/common/models/chapter.dart' as mc;

class NovelDownloadSheet {
  static void show(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<SourceChapter>> chapters,
    Set<String> readState,
    Set<String> downloadedState,
    String novelUrl,
    String sourceId,
  ) {
    final list = chapters.valueOrNull ?? const <SourceChapter>[];
    if (list.isEmpty) return;
    
    final sorted = [...list];
    sorted.sort((a, b) {
      final an = a.number ?? -1;
      final bn = b.number ?? -1;
      return an.compareTo(bn);
    });
    
    final controller = ref.read(novelDetailControllerProvider);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _downloadOption(
              ctx,
              ref,
              'Download all unread',
              Icons.download_for_offline_rounded,
              sorted
                  .where(
                    (c) =>
                        !controller.containsNormalized(readState, c.url) &&
                        !controller.containsNormalized(downloadedState, c.url),
                  )
                  .toList(),
              novelUrl,
              sourceId,
            ),
            _downloadOption(
              ctx,
              ref,
              'Download next 10',
              Icons.exposure_plus_1_rounded,
              sorted
                  .where(
                    (c) =>
                        !controller.containsNormalized(readState, c.url) &&
                        !controller.containsNormalized(downloadedState, c.url),
                  )
                  .take(10)
                  .toList(),
              novelUrl,
              sourceId,
            ),
            _downloadOption(
              ctx,
              ref,
              'Download next 25',
              Icons.looks_two_rounded,
              sorted
                  .where(
                    (c) =>
                        !controller.containsNormalized(readState, c.url) &&
                        !controller.containsNormalized(downloadedState, c.url),
                  )
                  .take(25)
                  .toList(),
              novelUrl,
              sourceId,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _downloadOption(
    BuildContext ctx,
    WidgetRef ref,
    String title,
    IconData icon,
    List<SourceChapter> candidates,
    String novelUrl,
    String sourceId,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () async {
        Navigator.pop(ctx);
        await ref
            .read(chapterDownloadControllerProvider.notifier)
            .enqueueMany(
              sourceId: sourceId,
              novelId: novelUrl,
              chapters: candidates
                  .map(
                    (c) => mc.Chapter(
                      id: c.url,
                      novelId: novelUrl,
                      url: c.url,
                      name: c.name,
                      number: (c.number ?? -1).toDouble(),
                    ),
                  )
                  .toList(),
            );
      },
    );
  }
}
