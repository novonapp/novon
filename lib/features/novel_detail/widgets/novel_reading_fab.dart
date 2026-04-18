import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/common/constants/router_constants.dart';
import '../../../core/providers/source_provider.dart';

/// Renders the action button for starting or continuing to read.
class NovelReadingFab extends StatelessWidget {
  final List<SourceChapter> resolvedChapters;
  final String lastChapterUrl;
  final String novelUrl;
  final String sourceId;
  final bool ascending;

  const NovelReadingFab({
    super.key,
    required this.resolvedChapters,
    required this.lastChapterUrl,
    required this.novelUrl,
    required this.sourceId,
    required this.ascending,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        final list = resolvedChapters;
        if (list.isEmpty) return;
        if (lastChapterUrl.isNotEmpty) {
          context.push(
            RouterConstants.reader(sourceId, novelUrl, lastChapterUrl),
          );
          return;
        }
        final sorted = [...list];
        sorted.sort((a, b) {
          final an = a.number ?? -1;
          final bn = b.number ?? -1;
          return ascending ? an.compareTo(bn) : bn.compareTo(an);
        });
        context.push(
          RouterConstants.reader(sourceId, novelUrl, sorted.first.url),
        );
      },
      icon: const Icon(Icons.play_arrow_rounded),
      label: Text(lastChapterUrl.isNotEmpty ? 'Continue' : 'Start Reading'),
    );
  }
}
