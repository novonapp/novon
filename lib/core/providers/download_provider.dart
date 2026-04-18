import 'dart:convert';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:novon/core/common/enums/chapter_download_status.dart';
import 'package:novon/features/statistics/providers/statistics_provider.dart';
import '../common/models/chapter.dart' as m;
import '../data/repositories/chapter_repository.dart';
import 'db_providers.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import '../services/extension_engine.dart';
import '../services/extension_loader.dart';

class ChapterDownloadInfo {
  final ChapterDownloadStatus status;
  final double progress;
  final String? taskId;
  final String? error;

  const ChapterDownloadInfo({
    required this.status,
    this.progress = 0,
    this.taskId,
    this.error,
  });

  ChapterDownloadInfo copyWith({
    ChapterDownloadStatus? status,
    double? progress,
    String? taskId,
    String? error,
  }) {
    return ChapterDownloadInfo(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      taskId: taskId ?? this.taskId,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'progress': progress,
    'taskId': taskId,
    'error': error,
  };

  static ChapterDownloadInfo fromJson(Map<String, dynamic> map) {
    final statusName = (map['status'] ?? 'queued').toString();
    final status = ChapterDownloadStatus.values.firstWhere(
      (s) => s.name == statusName,
      orElse: () => ChapterDownloadStatus.queued,
    );
    return ChapterDownloadInfo(
      status: status,
      progress: ((map['progress'] as num?) ?? 0).toDouble(),
      taskId: map['taskId']?.toString(),
      error: map['error']?.toString(),
    );
  }
}

final chapterDownloadControllerProvider =
    StateNotifierProvider<
      ChapterDownloadController,
      Map<String, ChapterDownloadInfo>
    >((ref) => ChapterDownloadController(ref));

final chapterDownloadInfoProvider =
    Provider.family<ChapterDownloadInfo?, String>((ref, chapterId) {
      return ref.watch(chapterDownloadControllerProvider)[chapterId];
    });

class ChapterDownloadController
    extends StateNotifier<Map<String, ChapterDownloadInfo>> {
  ChapterDownloadController(this.ref) : super(const {}) {
    _hydrate();
    _registerCallbacks();
  }

  final Ref ref;

  void _hydrate() {
    final box = Hive.box(HiveBox.app);
    final raw = box.get(HiveKeys.downloadTaskState);
    if (raw is! Map) return;
    final parsed = <String, ChapterDownloadInfo>{};
    for (final e in raw.entries) {
      if (e.value is Map) {
        parsed[e.key.toString()] = ChapterDownloadInfo.fromJson(
          Map<String, dynamic>.from(e.value as Map),
        );
      }
    }
    state = parsed;
  }

  Future<void> _persist() async {
    final box = Hive.box(HiveBox.app);
    final out = <String, dynamic>{};
    for (final e in state.entries) {
      out[e.key] = e.value.toJson();
    }
    await box.put(HiveKeys.downloadTaskState, out);
  }

  void _registerCallbacks() {
    FileDownloader().registerCallbacks(
      taskStatusCallback: (update) => _onStatusUpdate(update),
      taskProgressCallback: (update) => _onProgressUpdate(update),
    );
  }

  Future<void> enqueueChapter({
    required String sourceId,
    required String novelId,
    required String chapterId,
    required String chapterName,
    required String chapterUrl,
  }) async {
    final safeName = chapterName
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final filename =
        '${safeName.isEmpty ? "chapter" : safeName}_${chapterId.hashCode}';
    final metadata = jsonEncode({
      'sourceId': sourceId,
      'novelId': novelId,
      'chapterId': chapterId,
      'chapterUrl': chapterUrl,
    });
    final task = DownloadTask(
      url: chapterUrl,
      filename: filename,
      updates: Updates.statusAndProgress,
      retries: 3,
      allowPause: true,
      metaData: metadata,
    );
    state = {
      ...state,
      chapterId: const ChapterDownloadInfo(
        status: ChapterDownloadStatus.queued,
        progress: 0,
      ),
    };
    await _persist();

    final ok = await FileDownloader().enqueue(task);
    if (!ok) {
      state = {
        ...state,
        chapterId: const ChapterDownloadInfo(
          status: ChapterDownloadStatus.failed,
          error: 'Failed to enqueue task',
        ),
      };
      await _persist();
    }
  }

  Future<void> enqueueMany({
    required String sourceId,
    required String novelId,
    required List<m.Chapter> chapters,
  }) async {
    for (final ch in chapters) {
      await enqueueChapter(
        sourceId: sourceId,
        novelId: novelId,
        chapterId: ch.id,
        chapterName: ch.name,
        chapterUrl: ch.url,
      );
    }
  }

  /// Orchestrates the removal of a specific download entry and its associated
  /// localized content.
  Future<void> removeDownload(String chapterId) async {
    final chapterRepo = ref.read(chapterRepositoryProvider);
    final chapter = await chapterRepo.getChapter(chapterId);

    if (chapter != null) {
      // Mark as NOT downloaded in SQLite.
      await chapterRepo.updateChapter(chapter.copyWith(downloaded: false));
      // Remove content from SQLite.
      await chapterRepo.deleteChapterContent(chapterId);
    }

    // Remove from in-memory state and persistence.
    final next = Map<String, ChapterDownloadInfo>.from(state);
    next.remove(chapterId);
    state = next;
    await _persist();
  }

  /// Executes an exhaustive liquidation of all localized download data and
  /// persistent configuration state.
  Future<void> clearAllDownloads() async {
    final db = ref.read(databaseProvider);

    // Reset all downloaded flags.
    await db.customStatement('UPDATE chapters SET downloaded = 0;');
    // Clear all content.
    await db.customStatement('DELETE FROM chapter_contents;');

    // Reset state.
    state = const {};
    await _persist();
  }

  void _onProgressUpdate(TaskProgressUpdate update) {
    final meta = _parseMeta(update.task.metaData);
    final chapterId = meta['chapterId']?.toString();
    if (chapterId == null || chapterId.isEmpty) return;
    final existing = state[chapterId];
    state = {
      ...state,
      chapterId:
          (existing ??
                  const ChapterDownloadInfo(
                    status: ChapterDownloadStatus.downloading,
                  ))
              .copyWith(
                status: ChapterDownloadStatus.downloading,
                progress: (update.progress * 100).clamp(0, 100),
                taskId: update.task.taskId,
              ),
    };
    _persist();
  }

  Future<void> _onStatusUpdate(TaskStatusUpdate update) async {
    final meta = _parseMeta(update.task.metaData);
    final chapterId = meta['chapterId']?.toString();
    if (chapterId == null || chapterId.isEmpty) return;

    final statusName = update.status.toString().toLowerCase();
    ChapterDownloadStatus mapped = ChapterDownloadStatus.queued;
    if (statusName.contains('running')) {
      mapped = ChapterDownloadStatus.downloading;
    }
    if (statusName.contains('complete')) {
      mapped = ChapterDownloadStatus.complete;
    }
    if (statusName.contains('failed')) mapped = ChapterDownloadStatus.failed;
    if (statusName.contains('paused')) mapped = ChapterDownloadStatus.paused;

    state = {
      ...state,
      chapterId: ChapterDownloadInfo(
        status: mapped,
        progress: mapped == ChapterDownloadStatus.complete
            ? 100
            : (state[chapterId]?.progress ?? 0),
        taskId: update.task.taskId,
        error: update.exception?.description,
      ),
    };
    await _persist();

    if (mapped == ChapterDownloadStatus.complete) {
      final chapterRepo = ref.read(chapterRepositoryProvider);
      // Wait for content to be cached BEFORE marking as downloaded
      final success = await _cacheChapterHtmlFromWeb(
        meta,
        chapterRepo: chapterRepo,
      );

      if (success) {
        final current = await chapterRepo.getChapter(chapterId);
        if (current != null && !current.downloaded) {
          await chapterRepo.updateChapter(current.copyWith(downloaded: true));
        }
      } else {
        // If caching failed, revert status to failed
        state = {
          ...state,
          chapterId: state[chapterId]!.copyWith(
            status: ChapterDownloadStatus.failed,
            error: 'Failed to extract and save chapter content locally.',
          ),
        };
        await _persist();
      }
    }
  }

  /// Returns true if the HTML was successfully parsed and saved into local storage.
  Future<bool> _cacheChapterHtmlFromWeb(
    Map<String, dynamic> meta, {
    required ChapterRepository chapterRepo,
  }) async {
    final sourceId = meta['sourceId']?.toString();
    final chapterUrl = meta['chapterUrl']?.toString();
    if (sourceId == null ||
        sourceId.isEmpty ||
        chapterUrl == null ||
        chapterUrl.isEmpty) {
      return false;
    }
    try {
      // Load extension script source for parsing.
      final loader = ExtensionLoader.instance;
      final script = await loader.loadScriptSource(sourceId);
      if (script == null) return false;

      // Use ExtensionEngine to fetch CONTENT, ensuring correct JS parsing.
      final engine = ExtensionEngine.instance;
      final result = await engine.fetchChapterContent(
        sourceId,
        script,
        chapterUrl,
      );

      final String html;
      if (result is String) {
        html = result;
      } else if (result is Map) {
        final map = Map<String, dynamic>.from(result);
        html =
            (map['content'] ?? map['html'] ?? map['text'] ?? map['data'] ?? '')
                .toString();
      } else {
        html = result?.toString() ?? '';
      }

      if (html.trim().isEmpty) return false;

      final variants = _chapterUrlVariants(chapterUrl);

      // Sync with Hive if needed (for legacy/cross-bridge support).
      final box = Hive.box(HiveBox.app);
      final raw = box.get(HiveKeys.chapterHtmlCache);
      final cache = raw is Map
          ? Map<String, dynamic>.from(raw)
          : <String, dynamic>{};

      for (final variant in variants) {
        final normalizedUrl = variant.trim().replaceAll(RegExp(r'/+$'), '');
        cache['$sourceId|$normalizedUrl'] = {
          'html': html,
          'savedAt': DateTime.now().toIso8601String(),
        };
      }
      await box.put(HiveKeys.chapterHtmlCache, cache);

      // Save to standardized SQLite repository.
      final chapter = await chapterRepo.getChapter(variants.first);
      await chapterRepo.cacheChapterContent(
        m.ChapterContent(
          chapterId: variants.first,
          html: html,
          title: chapter?.name,
          fetchedAt: DateTime.now(),
        ),
      );

      return true;
    } catch (_) {
      // Download failed to cache content locally.
      return false;
    }
  }

  Map<String, dynamic> _parseMeta(String? raw) {
    if (raw == null || raw.isEmpty) return const {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return const {};
    } catch (_) {
      return const {};
    }
  }

  String _safeDecodeUrl(String value) {
    try {
      return Uri.decodeComponent(value);
    } catch (_) {
      return value;
    }
  }

  List<String> _chapterUrlVariants(String chapterUrl) {
    final variants = <String>{};
    final trimmed = chapterUrl.trim();
    if (trimmed.isNotEmpty) variants.add(trimmed);
    final withoutSlash = trimmed.replaceAll(RegExp(r'/+$'), '');
    if (withoutSlash.isNotEmpty) variants.add(withoutSlash);
    final decoded = _safeDecodeUrl(trimmed);
    if (decoded.isNotEmpty) variants.add(decoded);
    final decodedNoSlash = decoded.replaceAll(RegExp(r'/+$'), '');
    if (decodedNoSlash.isNotEmpty) variants.add(decodedNoSlash);
    final encoded = Uri.encodeFull(
      decodedNoSlash.isNotEmpty ? decodedNoSlash : decoded,
    );
    if (encoded.isNotEmpty) variants.add(encoded);
    final encodedNoSlash = encoded.replaceAll(RegExp(r'/+$'), '');
    if (encodedNoSlash.isNotEmpty) variants.add(encodedNoSlash);
    return variants.toList();
  }
}
