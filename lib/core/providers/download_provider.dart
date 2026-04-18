import 'dart:async';
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
      return ref.watch(
        chapterDownloadControllerProvider.select((state) => state[chapterId]),
      );
    });

/// Manages the lifecycle of chapter download tasks, providing debounced state
/// emission and throttled persistence to prevent UI thread starvation during
/// high-volume bulk download operations.
class ChapterDownloadController
    extends StateNotifier<Map<String, ChapterDownloadInfo>> {
  ChapterDownloadController(this.ref) : super(const {}) {
    _hydrate();
    _registerCallbacks();
  }

  final Ref ref;

  /// Accumulates state mutations between debounce ticks. Updated synchronously
  /// from callbacks without triggering Riverpod rebuilds until flushed.
  final Map<String, ChapterDownloadInfo> _pending = {};

  /// Timer for debouncing progress emissions. Batches rapid-fire progress
  /// updates into a single Riverpod state emission per tick.
  Timer? _emitTimer;

  /// Timer for debouncing Hive persistence. Writes at most once per interval.
  Timer? _persistTimer;
  bool _persistScheduled = false;

  static const _emitInterval = Duration(milliseconds: 300);
  static const _persistInterval = Duration(milliseconds: 500);

  @override
  void dispose() {
    _emitTimer?.cancel();
    _persistTimer?.cancel();
    super.dispose();
  }

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
    _pending.addAll(parsed);
  }

  /// Persists the current state to Hive immediately.
  Future<void> _persistNow() async {
    final box = Hive.box(HiveBox.app);
    final out = <String, dynamic>{};
    for (final e in state.entries) {
      out[e.key] = e.value.toJson();
    }
    await box.put(HiveKeys.downloadTaskState, out);
  }

  /// Schedules a debounced persist. Multiple calls within the interval
  /// collapse into a single Hive write.
  void _schedulePersist() {
    if (_persistScheduled) return;
    _persistScheduled = true;
    _persistTimer?.cancel();
    _persistTimer = Timer(_persistInterval, () {
      _persistScheduled = false;
      _persistNow();
    });
  }

  /// Flushes all pending mutations into a single Riverpod state emission
  /// and schedules a debounced Hive persist.
  void _flushPending() {
    if (!mounted) return;
    state = Map<String, ChapterDownloadInfo>.from(_pending);
    _schedulePersist();
  }

  /// Schedules a debounced state emission.
  /// accumulate in _pending and get flushed as one batch per tick.
  void _scheduleEmit() {
    if (_emitTimer?.isActive == true) return;
    _emitTimer = Timer(_emitInterval, _flushPending);
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

    _pending[chapterId] = const ChapterDownloadInfo(
      status: ChapterDownloadStatus.queued,
      progress: 0,
    );
    _flushPending();

    final ok = await FileDownloader().enqueue(task);
    if (!ok) {
      _pending[chapterId] = const ChapterDownloadInfo(
        status: ChapterDownloadStatus.failed,
        error: 'Failed to enqueue task',
      );
      _flushPending();
    }
  }

  Future<void> enqueueMany({
    required String sourceId,
    required String novelId,
    required List<m.Chapter> chapters,
  }) async {
    if (chapters.isEmpty) return;

    // Yield control to let UI animations (like closing the bottom sheet) finish.
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    final tasks = <DownloadTask>[];

    // Construct tasks in small batches. Passing thousands of strings through
    // regex and JSON encoders on the main thread will cause frame drops.
    const constructBatchSize = 15;
    for (var i = 0; i < chapters.length; i += constructBatchSize) {
      final end = (i + constructBatchSize).clamp(0, chapters.length);
      for (var j = i; j < end; j++) {
        final ch = chapters[j];
        _pending[ch.id] = const ChapterDownloadInfo(
          status: ChapterDownloadStatus.queued,
          progress: 0,
        );

        final safeName = ch.name
            .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
        final filename =
            '${safeName.isEmpty ? "chapter" : safeName}_${ch.id.hashCode}';
        final metadata = jsonEncode({
          'sourceId': sourceId,
          'novelId': novelId,
          'chapterId': ch.id,
          'chapterUrl': ch.url,
        });

        tasks.add(
          DownloadTask(
            url: ch.url,
            filename: filename,
            updates: Updates.status,
            retries: 3,
            allowPause: true,
            metaData: metadata,
          ),
        );
      }
      // Yield 2ms between heavy allocations to give the event loop breathing room.
      if (end < chapters.length) {
        await Future.delayed(const Duration(milliseconds: 2));
      }
    }

    // Emit state changes to Riverpod once.
    // We intentionally rely on `_schedulePersist` inside `_flushPending`
    // rather than calling `await _persistNow()` here. Serializing the entire
    // state map to JSON for Hive blocks the UI thread heavily. Deflecting it
    // saves major frames.
    _flushPending();

    // Stagger platform channel IPC calls heavily.
    // As requested, introduce explicit latency between EACH chapter download.
    // This creates a cascade effect that:
    // 1. Spreads out platform channel IPC overhead.
    // 2. Prevents network bandwidth saturation.
    // 3. Prevents the "JavaScript parsing storm" where 25 chapters finish
    //    downloading simultaneously and immediately lock the UI thread
    //    executing 25 V8 engine parses back-to-back.
    for (var i = 0; i < tasks.length; i++) {
      if (!mounted) return;
      FileDownloader().enqueue(tasks[i]);

      if (i < tasks.length - 1) {
        // Enqueue one chapter every 600ms
        await Future.delayed(const Duration(milliseconds: 600));
      }
    }
  }

  /// Orchestrates the removal of a specific download entry and its associated
  /// localized content.
  Future<void> removeDownload(String chapterId) async {
    final chapterRepo = ref.read(chapterRepositoryProvider);
    final chapter = await chapterRepo.getChapter(chapterId);

    if (chapter != null) {
      await chapterRepo.updateChapter(chapter.copyWith(downloaded: false));
      await chapterRepo.deleteChapterContent(chapterId);
    }

    _pending.remove(chapterId);
    _flushPending();
    await _persistNow();
  }

  /// Executes an exhaustive liquidation of all localized download data and
  /// persistent configuration state.
  Future<void> clearAllDownloads() async {
    final db = ref.read(databaseProvider);

    await db.customStatement('UPDATE chapters SET downloaded = 0;');
    await db.customStatement('DELETE FROM chapter_contents;');

    _pending.clear();
    state = const {};
    await _persistNow();
  }

  void _onProgressUpdate(TaskProgressUpdate update) {
    final meta = _parseMeta(update.task.metaData);
    final chapterId = meta['chapterId']?.toString();
    if (chapterId == null || chapterId.isEmpty) return;

    final existing = _pending[chapterId];
    _pending[chapterId] =
        (existing ??
                const ChapterDownloadInfo(
                  status: ChapterDownloadStatus.downloading,
                ))
            .copyWith(
              status: ChapterDownloadStatus.downloading,
              progress: (update.progress * 100).clamp(0, 100),
              taskId: update.task.taskId,
            );

    // Debounced: accumulate in _pending, flush on next timer tick.
    _scheduleEmit();
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

    _pending[chapterId] = ChapterDownloadInfo(
      status: mapped,
      progress: mapped == ChapterDownloadStatus.complete
          ? 100
          : (_pending[chapterId]?.progress ?? 0),
      taskId: update.task.taskId,
      error: update.exception?.description,
    );

    // Status changes are important, flush immediately rather than debouncing.
    _flushPending();

    if (mapped == ChapterDownloadStatus.complete) {
      final chapterRepo = ref.read(chapterRepositoryProvider);
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
        _pending[chapterId] = _pending[chapterId]!.copyWith(
          status: ChapterDownloadStatus.failed,
          error: 'Failed to extract and save chapter content locally.',
        );
        _flushPending();
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
      final loader = ExtensionLoader.instance;
      final script = await loader.loadScriptSource(sourceId);
      if (script == null) return false;

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
