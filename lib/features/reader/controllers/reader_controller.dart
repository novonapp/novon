import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/common/models/reading_position.dart';
import '../../../core/providers/db_providers.dart';
import '../providers/reader_settings_provider.dart';
import '../../../core/common/constants/hive_constants.dart';

final readerControllerProvider = Provider<ReaderController>((ref) {
  return ReaderController(ref);
});

/// Pre-compiled regular expression cached at the module level to eliminate
/// redundant per-call allocation during high-frequency scroll and navigation
/// operations.
final RegExp _trailingSlashPattern = RegExp(r'/+$');

/// Orchestrates the consumption state and environmental configuration for the
/// content reader, facilitating progress persistence and settings management.
class ReaderController {
  final Ref ref;
  ReaderController(this.ref);

  /// Persists reader-specific visual configuration to global state and
  /// persistent storage for cross-session consistency.
  Future<void> saveReaderSettings({
    required double fontSize,
    required double lineHeight,
    required String fontFamily,
    required Color background,
    required Color text,
  }) async {
    ref.read(readerFontSizeProvider.notifier).state = fontSize;
    ref.read(readerLineHeightProvider.notifier).state = lineHeight;
    ref.read(readerFontFamilyProvider.notifier).state = fontFamily;

    final box = Hive.box(HiveBox.reader);
    await box.put(HiveKeys.readerFontSize, fontSize);
    await box.put(HiveKeys.readerLineHeight, lineHeight);
    await box.put(HiveKeys.readerFontFamily, fontFamily);
    await box.put(HiveKeys.readerCustomBg, background.toARGB32());
    await box.put(HiveKeys.readerCustomText, text.toARGB32());
  }

  double getSavedChapterProgressPercent(
    String sourceId,
    String novelUrl,
    String chapterUrl,
  ) {
    final box = Hive.box(HiveBox.app);
    final raw = box.get(HiveKeys.chapterProgress);
    if (raw is! Map) return 0;

    final all = Map<String, dynamic>.from(raw);
    final novelKey = '$sourceId|$novelUrl';
    final novelMapRaw = all[novelKey];
    if (novelMapRaw is! Map) return 0;

    final novelMap = Map<String, dynamic>.from(novelMapRaw);

    for (final variant in chapterUrlVariants(chapterUrl)) {
      final direct = double.tryParse((novelMap[variant] ?? '').toString());
      if (direct != null) return direct.clamp(0, 100).toDouble();

      final normalizedTarget =
          variant.replaceAll(_trailingSlashPattern, '');
      for (final entry in novelMap.entries) {
        final key =
            entry.key.toString().replaceAll(_trailingSlashPattern, '');
        if (key == normalizedTarget) {
          return (double.tryParse(entry.value.toString()) ?? 0)
              .clamp(0, 100)
              .toDouble();
        }
      }
    }
    return 0;
  }

  /// Synchronizes the current segment's consumption metrics across multiple
  /// persistence layers.
  ///
  /// Updates local Hive caches for immediate UI reactivity and relative pathing,
  /// while asynchronously committing historical records and position anchors
  /// to the underlying database for statistical integrity.
  void persistProgress({
    required String sourceId,
    required String novelUrl,
    required String chapterUrl,
    required double progressPercent,
    required int pendingTimeSpentMs,
    bool forceComplete = false,
  }) {
    final chapterRepo = ref.read(chapterRepositoryProvider);
    final historyRepo = ref.read(historyRepositoryProvider);
    final box = Hive.box(HiveBox.app);

    final effectivePercent = forceComplete ? 100.0 : progressPercent;

    final raw = box.get(HiveKeys.chapterProgress);
    final all = raw is Map
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    final novelKey = '$sourceId|$novelUrl';
    final novelMap = all[novelKey] is Map
        ? Map<String, dynamic>.from(all[novelKey] as Map)
        : <String, dynamic>{};

    for (final variant in chapterUrlVariants(chapterUrl)) {
      novelMap[variant] = effectivePercent;
    }
    all[novelKey] = novelMap;
    box.put(HiveKeys.chapterProgress, all);

    final rawLast = box.get(HiveKeys.novelLastChapter);
    final lastMap = rawLast is Map
        ? Map<String, dynamic>.from(rawLast)
        : <String, dynamic>{};
    lastMap[novelKey] = chapterUrl;
    box.put(HiveKeys.novelLastChapter, lastMap);

    chapterRepo.updateReadingPosition(
      chapterUrl,
      effectivePercent.round(),
      effectivePercent / 100.0,
    );

    if (effectivePercent >= 99.9) {
      chapterRepo.markChapterRead(chapterUrl);
    }

    if (pendingTimeSpentMs > 0 || effectivePercent > 0 || forceComplete) {
      historyRepo.upsertHistory(
        ReadingPosition(
          chapterId: chapterUrl,
          novelId: novelUrl,
          scrollOffset: effectivePercent / 100.0,
          lastRead: DateTime.now(),
          timeSpentMs: pendingTimeSpentMs,
        ),
      );
    }
  }

  Future<void> markChapterRead(String chapterUrl) async {
    final chapterRepo = ref.read(chapterRepositoryProvider);
    await chapterRepo.markChapterRead(chapterUrl);
  }

  /// Derives canonical permutations for segment identifiers to ensure
  /// resilient state mapping across heterogeneous content delivery sources.
  List<String> chapterUrlVariants(String url) {
    final variants = <String>{};
    final raw = url.trim();
    if (raw.isNotEmpty) variants.add(raw);
    final noSlash = raw.replaceAll(_trailingSlashPattern, '');
    if (noSlash.isNotEmpty) variants.add(noSlash);
    final decoded = _safeDecode(raw);
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
