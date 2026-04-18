import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/common/models/novel.dart' as m;
import '../../../core/common/models/chapter.dart' as mc;
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/services/novel_metadata_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/common/constants/hive_constants.dart';

final novelDetailControllerProvider = Provider<NovelDetailController>((ref) {
  return NovelDetailController(ref);
});

/// Pre-compiled regular expressions cached as static constants to eliminate
/// redundant per-call allocation overhead during high-frequency chapter
/// iteration cycles.
final RegExp _trailingSlashPattern = RegExp(r'/+$');

/// Primary orchestration layer for novel-specific metadata and structural state,
/// facilitating library synchronization, metadata archival, and
/// content segment indexing.
class NovelDetailController {
  final Ref ref;
  NovelDetailController(this.ref);

  /// Toggles the inclusion of a novel in the user's local library.
  ///
  /// Implementation utilizes a non-destructive removal strategy with a 3-day
  /// grace period to prevent accidental data loss of reading progress or
  /// downloaded content.
  Future<void> toggleLibrary(
    BuildContext context,
    String sourceId,
    String novelUrl,
    AsyncValue<SourceNovelDetail> detail,
    AsyncValue<bool> inLibrary, {
    String? initialTitle,
    String? initialCoverUrl,
  }) async {
    final isAlreadyInLib = inLibrary.valueOrNull == true;
    final repo = ref.read(novelRepositoryProvider);

    if (isAlreadyInLib) {
      await repo.removeFromLibrary(novelUrl);
      // Schedule 3-day grace period cleanup instead of immediate delete.
      NovelMetadataService.scheduleGracePeriodCleanup(novelUrl);
      return;
    }

    final d = detail.valueOrNull;
    if (d == null) return;

    // Cancel any pending grace period cleanup (re-added to library).
    NovelMetadataService.cancelGracePeriodCleanup(novelUrl);

    final novel = m.Novel(
      id: novelUrl,
      sourceId: sourceId,
      url: novelUrl,
      title: d.title.isEmpty ? (initialTitle ?? 'Unknown') : d.title,
      author: d.author ?? '',
      description: d.description ?? '',
      coverUrl: (d.coverUrl == null || d.coverUrl!.isEmpty)
          ? (initialCoverUrl ?? '')
          : d.coverUrl!,
      status: m.NovelStatus.unknown,
      genres: d.genres,
      inLibrary: true,
      lastFetched: DateTime.now(),
    );

    await repo.insertNovel(novel);
    await repo.addToLibrary(novelUrl);

    // Download cover to local storage in the background.
    NovelMetadataService.instance.initializeLocalCache(
      novel: novel,
      novelRepo: repo,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added to library')));
    }
  }

  /// Orchestrates the externalization of novel identifiers via platform-native
  /// sharing interfaces.
  Future<void> shareNovel(
    AsyncValue<SourceNovelDetail> detail,
    String novelUrl,
  ) async {
    final title = detail.valueOrNull?.title;
    await SharePlus.instance.share(
      ShareParams(
        text: novelUrl,
        subject: title?.isNotEmpty == true ? title : 'Novel',
      ),
    );
  }

  /// Orchestrates the appraisal and transition of a chapter's consumption state.
  Future<bool> toggleChapterRead(
    BuildContext context,
    String chapterUrl,
    bool isRead,
  ) async {
    final repo = ref.read(chapterRepositoryProvider);
    if (isRead) {
      await repo.markChapterUnread(chapterUrl);
    } else {
      await repo.markChapterRead(chapterUrl);
    }

    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isRead ? 'Marked as unread' : 'Marked as read'),
        duration: const Duration(milliseconds: 900),
      ),
    );
    return false;
  }

  /// Synchronizes remote chapter listings with the local repository, performing
  /// a differential update (upsert) to preserve localized user data such as
  /// read status and offline availability.
  Future<void> persistFetchedChapters(
    String novelUrl,
    List<SourceChapter> chapters,
  ) async {
    final chapterRepo = ref.read(chapterRepositoryProvider);
    final existing = await chapterRepo.getChaptersForNovel(novelUrl);
    final existingById = {for (final c in existing) c.id: c};

    final toSave = chapters.map((ch) {
      final old = existingById[ch.url];
      return mc.Chapter(
        id: ch.url,
        novelId: novelUrl,
        url: ch.url,
        name: ch.name,
        number: (ch.number ?? -1).toDouble(),
        read: old?.read ?? false,
        downloaded: old?.downloaded ?? false,
        lastPageRead: old?.lastPageRead ?? 0,
      );
    }).toList();

    await chapterRepo.upsertChapters(toSave);
  }

  /// Retrieves the localized relational flag for chapter ordering preferences
  /// associated with the specific novel.
  Future<bool> loadChapterSortPreference(String novelUrl) async {
    final box = Hive.box(HiveBox.app);
    return box.get(HiveKeys.globalChapterSortAscending, defaultValue: true)
        as bool;
  }

  /// Persists a localized relational flag to determine the chronological
  /// ordering of content segments.
  Future<void> persistChapterSortPreference(
    String novelUrl,
    bool ascending,
  ) async {
    final box = Hive.box(HiveBox.app);
    await box.put(HiveKeys.globalChapterSortAscending, ascending);
  }

  /// Pre-computes O(1) lookup maps for read-state and progress from the raw
  /// data, amortizing the expensive URL variant computation once per build
  /// rather than once per chapter tile.
  ///
  /// Returns a [Map<String, bool>] where every normalized variant of each
  /// read chapter URL maps to `true`.
  Map<String, bool> buildReadLookup(Set<String> readState) {
    final lookup = <String, bool>{};
    for (final url in readState) {
      for (final variant in chapterUrlVariants(url)) {
        lookup[variant.replaceAll(_trailingSlashPattern, '')] = true;
      }
    }
    return lookup;
  }

  /// Pre-computes an O(1) lookup map for per-chapter progress percentages.
  ///
  /// Returns a [Map<String, double>] where every normalized variant maps to
  /// the stored progress value.
  Map<String, double> buildProgressLookup(Map<String, dynamic> progressMap) {
    final lookup = <String, double>{};
    for (final entry in progressMap.entries) {
      final value = double.tryParse(entry.value.toString()) ?? 0;
      if (value <= 0) continue;
      for (final variant in chapterUrlVariants(entry.key)) {
        lookup[variant.replaceAll(_trailingSlashPattern, '')] = value;
      }
    }
    return lookup;
  }

  /// O(1) read-state check using a pre-computed lookup map.
  bool isChapterRead(Map<String, bool> readLookup, String chapterUrl) {
    for (final variant in chapterUrlVariants(chapterUrl)) {
      if (readLookup[variant.replaceAll(_trailingSlashPattern, '')] == true) {
        return true;
      }
    }
    return false;
  }

  /// O(1) progress lookup using a pre-computed lookup map.
  double progressFromLookup(
    Map<String, double> progressLookup,
    String chapterUrl,
  ) {
    for (final variant in chapterUrlVariants(chapterUrl)) {
      final value =
          progressLookup[variant.replaceAll(_trailingSlashPattern, '')];
      if (value != null) return value;
    }
    return 0;
  }

  /// Appraises the specific consumption telemetry for a segment across a
  /// comprehensive set of identifier permutations.
  double progressFor(Map<String, dynamic> progressMap, String chapterUrl) {
    for (final variant in chapterUrlVariants(chapterUrl)) {
      final direct = double.tryParse((progressMap[variant] ?? '').toString());
      if (direct != null) return direct;
    }

    final normalizedVariants = chapterUrlVariants(
      chapterUrl,
    ).map((u) => u.replaceAll(_trailingSlashPattern, '')).toSet();

    for (final entry in progressMap.entries) {
      final keyVariants = chapterUrlVariants(
        entry.key.toString(),
      ).map((u) => u.replaceAll(_trailingSlashPattern, ''));
      if (keyVariants.any(normalizedVariants.contains)) {
        return double.tryParse(entry.value.toString()) ?? 0;
      }
    }
    return 0;
  }

  /// Appraises whether an identifier variant exists within the provided
  /// normalized collection.
  bool containsNormalized(Set<String> values, String url) {
    final targetVariants = chapterUrlVariants(
      url,
    ).map((u) => u.replaceAll(_trailingSlashPattern, '')).toSet();

    for (final value in values) {
      final valueVariants = chapterUrlVariants(
        value,
      ).map((u) => u.replaceAll(_trailingSlashPattern, ''));
      if (valueVariants.any(targetVariants.contains)) return true;
    }
    return false;
  }

  /// Generates a comprehensive set of URL permutations (normalized, encoded,
  /// decoded) to ensure resilient mapping across different extension
  /// implementations and repository schemas.
  List<String> chapterUrlVariants(String chapterUrl) {
    final variants = <String>{};
    final trimmed = chapterUrl.trim();
    if (trimmed.isNotEmpty) variants.add(trimmed);
    final withoutSlash = trimmed.replaceAll(_trailingSlashPattern, '');
    if (withoutSlash.isNotEmpty) variants.add(withoutSlash);
    final decoded = _safeDecode(trimmed);
    if (decoded.isNotEmpty) variants.add(decoded);
    final decodedNoSlash = decoded.replaceAll(_trailingSlashPattern, '');
    if (decodedNoSlash.isNotEmpty) variants.add(decodedNoSlash);
    final encoded = Uri.encodeFull(
      decodedNoSlash.isNotEmpty ? decodedNoSlash : decoded,
    );
    if (encoded.isNotEmpty) variants.add(encoded);
    final encodedNoSlash = encoded.replaceAll(_trailingSlashPattern, '');
    if (encodedNoSlash.isNotEmpty) variants.add(encodedNoSlash);
    return variants.toList(growable: false);
  }

  String _safeDecode(String value) {
    try {
      return Uri.decodeComponent(value);
    } catch (_) {
      return value;
    }
  }
}
