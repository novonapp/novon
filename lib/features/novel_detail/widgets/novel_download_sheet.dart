import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/providers/download_provider.dart';
import '../../../core/common/models/chapter.dart' as mc;
import '../../../core/theme/novon_colors.dart';

/// Data transfer object for passing chapter filtering parameters to an isolate.
class _FilterParams {
  final List<Map<String, dynamic>> chapters;
  final Set<String> readState;
  final Set<String> downloadedState;

  const _FilterParams({
    required this.chapters,
    required this.readState,
    required this.downloadedState,
  });
}

/// Result from the isolate computation containing pre-filtered chapter lists
/// ready for immediate UI rendering.
class _FilterResult {
  final List<Map<String, dynamic>> allUnread;
  final List<Map<String, dynamic>> next10;
  final List<Map<String, dynamic>> next25;

  const _FilterResult({
    required this.allUnread,
    required this.next10,
    required this.next25,
  });
}

/// Top-level function for use with compute(). Runs the expensive URL-variant
/// filtering on a separate isolate to prevent UI thread stalling.
_FilterResult _computeFilteredChapters(_FilterParams params) {
  final trailingSlash = RegExp(r'/+$');

  List<String> urlVariants(String chapterUrl) {
    final variants = <String>{};
    final trimmed = chapterUrl.trim();
    if (trimmed.isNotEmpty) variants.add(trimmed);
    final withoutSlash = trimmed.replaceAll(trailingSlash, '');
    if (withoutSlash.isNotEmpty) variants.add(withoutSlash);
    String safeDecode(String v) {
      try {
        return Uri.decodeComponent(v);
      } catch (_) {
        return v;
      }
    }

    final decoded = safeDecode(trimmed);
    if (decoded.isNotEmpty) variants.add(decoded);
    final decodedNoSlash = decoded.replaceAll(trailingSlash, '');
    if (decodedNoSlash.isNotEmpty) variants.add(decodedNoSlash);
    final encoded = Uri.encodeFull(
      decodedNoSlash.isNotEmpty ? decodedNoSlash : decoded,
    );
    if (encoded.isNotEmpty) variants.add(encoded);
    final encodedNoSlash = encoded.replaceAll(trailingSlash, '');
    if (encodedNoSlash.isNotEmpty) variants.add(encodedNoSlash);
    return variants.toList();
  }

  // Pre-build normalized lookup sets for O(1) membership checks.
  final readNormalized = <String>{};
  for (final url in params.readState) {
    for (final v in urlVariants(url)) {
      readNormalized.add(v.replaceAll(trailingSlash, ''));
    }
  }
  final downloadedNormalized = <String>{};
  for (final url in params.downloadedState) {
    for (final v in urlVariants(url)) {
      downloadedNormalized.add(v.replaceAll(trailingSlash, ''));
    }
  }

  bool containsAny(Set<String> lookup, String url) {
    for (final v in urlVariants(url)) {
      if (lookup.contains(v.replaceAll(trailingSlash, ''))) return true;
    }
    return false;
  }

  // Sort ascending by chapter number.
  final sorted = List<Map<String, dynamic>>.from(params.chapters);
  sorted.sort((a, b) {
    final an = (a['number'] as num?) ?? -1;
    final bn = (b['number'] as num?) ?? -1;
    return an.compareTo(bn);
  });

  final allUnread = sorted
      .where(
        (c) =>
            !containsAny(readNormalized, c['url'] as String) &&
            !containsAny(downloadedNormalized, c['url'] as String),
      )
      .toList();

  return _FilterResult(
    allUnread: allUnread,
    next10: allUnread.take(10).toList(),
    next25: allUnread.take(25).toList(),
  );
}

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

    showModalBottomSheet(
      context: context,
      builder: (ctx) => _DownloadSheetContent(
        chapters: list,
        readState: readState,
        downloadedState: downloadedState,
        novelUrl: novelUrl,
        sourceId: sourceId,
      ),
    );
  }
}

class _DownloadSheetContent extends ConsumerStatefulWidget {
  final List<SourceChapter> chapters;
  final Set<String> readState;
  final Set<String> downloadedState;
  final String novelUrl;
  final String sourceId;

  const _DownloadSheetContent({
    required this.chapters,
    required this.readState,
    required this.downloadedState,
    required this.novelUrl,
    required this.sourceId,
  });

  @override
  ConsumerState<_DownloadSheetContent> createState() =>
      _DownloadSheetContentState();
}

class _DownloadSheetContentState extends ConsumerState<_DownloadSheetContent> {
  _FilterResult? _result;

  @override
  void initState() {
    super.initState();
    _computeFilters();
  }

  Future<void> _computeFilters() async {
    final serialized = widget.chapters
        .map((c) => {
              'name': c.name,
              'url': c.url,
              'number': c.number,
            })
        .toList();

    final result = await compute(
      _computeFilteredChapters,
      _FilterParams(
        chapters: serialized,
        readState: widget.readState,
        downloadedState: widget.downloadedState,
      ),
    );

    if (mounted) setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: NovonColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Preparing downloads...',
                style: TextStyle(color: NovonColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _downloadOption(
            context,
            ref,
            'Download all unread',
            Icons.download_for_offline_rounded,
            _result!.allUnread,
            widget.novelUrl,
            widget.sourceId,
          ),
          _downloadOption(
            context,
            ref,
            'Download next 10',
            Icons.exposure_plus_1_rounded,
            _result!.next10,
            widget.novelUrl,
            widget.sourceId,
          ),
          _downloadOption(
            context,
            ref,
            'Download next 25',
            Icons.looks_two_rounded,
            _result!.next25,
            widget.novelUrl,
            widget.sourceId,
          ),
        ],
      ),
    );
  }

  Widget _downloadOption(
    BuildContext ctx,
    WidgetRef ref,
    String title,
    IconData icon,
    List<Map<String, dynamic>> candidates,
    String novelUrl,
    String sourceId,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        '${candidates.length} chapters',
        style: TextStyle(color: NovonColors.textTertiary, fontSize: 12),
      ),
      onTap: () {
        Navigator.pop(ctx);
        ref
            .read(chapterDownloadControllerProvider.notifier)
            .enqueueMany(
              sourceId: sourceId,
              novelId: novelUrl,
              chapters: candidates
                  .map(
                    (c) => mc.Chapter(
                      id: c['url'] as String,
                      novelId: novelUrl,
                      url: c['url'] as String,
                      name: c['name'] as String,
                      number: ((c['number'] as num?) ?? -1).toDouble(),
                    ),
                  )
                  .toList(),
            );
      },
    );
  }
}
