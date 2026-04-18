import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/providers/db_providers.dart';
import '../providers/reader_settings_provider.dart';
import '../../../core/providers/source_provider.dart';
import '../widgets/reader_top_bar.dart';
import '../widgets/reader_bottom_bar.dart';
import '../widgets/reader_content_body.dart';
import '../widgets/reader_settings_sheet.dart';
import '../widgets/reader_page_skeleton.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import 'package:novon/core/common/constants/router_constants.dart';
import '../controllers/reader_controller.dart';
import '../../../core/utils/html_parse_isolate.dart';
import '../../../core/providers/extension_provider.dart';

/// Pre-compiled regular expressions used across reader operations.
/// Declared at the module level to eliminate per-call allocation overhead.
final RegExp _trailingSlashRx = RegExp(r'/+$');
final RegExp _chapterNumberRx = RegExp(r'(\d+)(?:/)?$');

/// The primary content consumption interface, providing a highly customizable 
/// environment for immersive reading.
class ReaderScreen extends ConsumerStatefulWidget {
  final String sourceId;
  final String novelId;
  final String chapterId;

  const ReaderScreen({
    super.key,
    required this.sourceId,
    required this.novelId,
    required this.chapterId,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _showControls = false;
  late AnimationController _controlsAnimation;
  late Animation<double> _controlsOpacity;
  final ScrollController _scrollController = ScrollController();
  bool _isNavigatingByScroll = false;
  double _fontSize = 17;
  double _lineHeight = 1.8;
  String _readerFontFamily = 'Alexandria';
  Color _readerBackground = NovonColors.background;
  Color _readerText = NovonColors.textPrimary;
  double _progressPercent = 0;
  final ValueNotifier<double> _progressPercentNotifier = ValueNotifier(0);
  double _bottomOverscroll = 0;
  double _topOverscroll = 0;
  bool _didRestoreInitialProgress = false;
  Timer? _progressDebounce;
  DateTime? _readingResumedAt;
  int _pendingTimeSpentMs = 0;

  /// Memoized paragraph state for isolate-parsed HTML content.
  /// [_cachedHtmlForParagraphs] tracks the input identity so we only re-parse
  /// when the chapter content actually changes.
  String? _cachedHtmlForParagraphs;
  Future<List<String>>? _paragraphsFuture;
  List<String>? _resolvedParagraphs;


  @override
  void initState() {
    super.initState();
    _applyInitialReaderSettings();
    WidgetsBinding.instance.addObserver(this);
    _controlsAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controlsOpacity = CurvedAnimation(
      parent: _controlsAnimation,
      curve: Curves.easeOut,
    );
    _scrollController.addListener(_onScroll);
    _resumeReadingTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  /// Monitors application lifecycle transitions to manage reading session 
  /// duration metrics and ensure structural state persistence during backgrounding.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumeReadingTimer();
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _pauseReadingTimer();
      _persistProgress();
    }
  }

  @override
  void dispose() {
    _progressDebounce?.cancel();
    _pauseReadingTimer();
    _persistProgress(useRepositories: false);
    _progressPercentNotifier.dispose();
    _scrollController.dispose();
    _controlsAnimation.dispose();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final readerController = ref.watch(readerControllerProvider);
    final novelUrl = _safeDecode(widget.novelId);
    final chapterUrl = _safeDecode(widget.chapterId);
    final savedPercent = readerController.getSavedChapterProgressPercent(
      widget.sourceId,
      novelUrl,
      chapterUrl,
    );
    if (!_didRestoreInitialProgress &&
        _progressPercent == 0 &&
        savedPercent > 0) {
      _progressPercent = savedPercent;
      _progressPercentNotifier.value = savedPercent;
    }
    final chapterList = ref.watch(
      sourceChapterListProvider((
        sourceId: widget.sourceId,
        novelUrl: novelUrl,
      )),
    );
    final novelDetail = ref.watch(
      sourceNovelDetailProvider((
        sourceId: widget.sourceId,
        novelUrl: novelUrl,
      )),
    );
    final chapterContent = ref.watch(
      sourceChapterContentProvider((
        sourceId: widget.sourceId,
        chapterUrl: chapterUrl,
      )),
    );
    final chapters = chapterList.valueOrNull ?? const <SourceChapter>[];
    final currentIndex = _findCurrentChapterIndex(chapters, chapterUrl);
    final currentChapter = (currentIndex >= 0 && currentIndex < chapters.length)
        ? chapters[currentIndex]
        : null;
    final chapterTitle = currentChapter?.name ??
        chapterContent.valueOrNull?.title ??
        _chapterTitleFromUrl(chapterUrl);
    final canGoPrevious =
        currentIndex >= 0 && currentIndex < chapters.length - 1;
    final canGoNext = currentIndex > 0;
    final novelTitle = novelDetail.valueOrNull?.title ?? 'Novel';

    return Scaffold(
      backgroundColor: _readerBackground,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Reader content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    _handleScrollNotification(
                      notification,
                      chapters: chapters,
                      currentIndex: currentIndex,
                      canGoNext: canGoNext,
                      canGoPrevious: canGoPrevious,
                    );
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            chapterTitle,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: NovonColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 16),
                          chapterContent.when(
                            loading: () => const ReaderPageSkeleton(),
                            error: (e, st) => Text(
                              'Failed to load chapter: $e',
                              style: TextStyle(
                                color: NovonColors.error,
                                fontSize: 14,
                              ),
                            ),
                            data: (content) {
                              final html = content.html.trim();
                              if (html.isEmpty) {
                                return Text(
                                  'No chapter content found.',
                                  style: TextStyle(
                                    color: NovonColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                );
                              }
                              // Restore call moved to snapshot.hasData below to ensure layout is ready
                              // _restoreInitialReadingPosition(chapterUrl);
                              // 1. Sync check global memory cache
                              final globalCached = getCachedParagraphsSynchronous(html);
                              if (globalCached != null) {
                                _resolvedParagraphs = globalCached;
                              }

                              // If already resolved (cache hit), render immediately.
                              if (_resolvedParagraphs != null) {
                                _restoreInitialReadingPosition(chapterUrl);
                                return ReaderContentBody(
                                  paragraphs: _resolvedParagraphs!,
                                  fontSize: _fontSize,
                                  lineHeight: _lineHeight,
                                  fontFamily: _readerFontFamily,
                                  textColor: _readerText,
                                );
                              }

                              // 2. Not globally cached; but if it's small enough, parse it instantly.
                              // This entirely skips the FutureBuilder and its Skeleton flash!
                              if (html.length < 500000) {
                                _resolvedParagraphs = parseHtmlToParagraphsSyncAndCache(html);
                                _restoreInitialReadingPosition(chapterUrl);
                                return ReaderContentBody(
                                  paragraphs: _resolvedParagraphs!,
                                  fontSize: _fontSize,
                                  lineHeight: _lineHeight,
                                  fontFamily: _readerFontFamily,
                                  textColor: _readerText,
                                );
                              }

                              // 3. For extremely huge chapters (>500k chars / ~100k words), 
                              // trigger async isolate parse so the UI doesn't completely freeze.
                              _ensureParagraphsParsed(html);

                              // Otherwise wait for isolate.
                              return FutureBuilder<List<String>>(
                                future: _paragraphsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    _resolvedParagraphs = snapshot.data!;
                                    // Restore position ONLY after content is layouted
                                    _restoreInitialReadingPosition(chapterUrl);
                                    return ReaderContentBody(
                                      paragraphs: snapshot.data!,
                                      fontSize: _fontSize,
                                      lineHeight: _lineHeight,
                                      fontFamily: _readerFontFamily,
                                      textColor: _readerText,
                                    );
                                  }
                                  return const ReaderPageSkeleton();
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Top controls
            if (_showControls)
              ReaderTopBar(
                novelTitle: novelTitle,
                chapterTitle: chapterTitle,
                progressNotifier: _progressPercentNotifier,
                controlsOpacity: _controlsOpacity,
                onBack: () {
                  _persistProgress();
                  Navigator.of(context).pop();
                },
                onWebView: () {
                  context.push(
                    RouterConstants.chapterWebview(chapterUrl, widget.sourceId),
                  );
                },
                onBookmark: () => readerController.markChapterRead(chapterUrl),
              ),

            // Bottom controls
            if (_showControls)
              ReaderBottomBar(
                canGoPrevious: canGoPrevious,
                canGoNext: canGoNext,
                controlsOpacity: _controlsOpacity,
                onPrevious: () => _openChapter(chapters[currentIndex + 1].url),
                onNext: () => _openChapter(chapters[currentIndex - 1].url),
                onSettings: () => _showReaderSettings(context),
              ),
          ],
        ),
      ),
    );
  }


  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _controlsAnimation.forward();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      } else {
        _controlsAnimation.reverse();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    });
  }

  bool get _isArabicSource {
    final installed = ref.read(installedExtensionsProvider).valueOrNull ?? [];
    for (final ext in installed) {
      if (ext.id == widget.sourceId) {
        return ext.lang == 'ar' || ext.lang.startsWith('ar-');
      }
    }
    return widget.sourceId.endsWith('_ar'); // Fallback
  }

  void _showReaderSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReaderSettingsSheet(
        fontSize: _fontSize,
        lineHeight: _lineHeight,
        fontFamily: _readerFontFamily,
        readerBackground: _readerBackground,
        readerText: _readerText,
        isArabicSource: _isArabicSource,
        onFontSizeChanged: (v) {
          setState(() => _fontSize = v);
          ref
              .read(readerControllerProvider)
              .saveReaderSettings(
                fontSize: _fontSize,
                lineHeight: _lineHeight,
                fontFamily: _readerFontFamily,
                background: _readerBackground,
                text: _readerText,
              );
        },
        onLineHeightChanged: (v) {
          setState(() => _lineHeight = v);
          ref
              .read(readerControllerProvider)
              .saveReaderSettings(
                fontSize: _fontSize,
                lineHeight: _lineHeight,
                fontFamily: _readerFontFamily,
                background: _readerBackground,
                text: _readerText,
              );
        },
        onFontFamilyChanged: (f) {
          setState(() => _readerFontFamily = f);
          ref
              .read(readerControllerProvider)
              .saveReaderSettings(
                fontSize: _fontSize,
                lineHeight: _lineHeight,
                fontFamily: _readerFontFamily,
                background: _readerBackground,
                text: _readerText,
              );
        },
        onThemeChanged: (bg, fg) {
          setState(() {
            _readerBackground = bg;
            _readerText = fg;
          });
          ref
              .read(readerControllerProvider)
              .saveReaderSettings(
                fontSize: _fontSize,
                lineHeight: _lineHeight,
                fontFamily: _readerFontFamily,
                background: _readerBackground,
                text: _readerText,
              );
        },
      ),
    );
  }


  void _resumeReadingTimer() {
    _readingResumedAt ??= DateTime.now();
  }

  void _pauseReadingTimer() {
    final startedAt = _readingResumedAt;
    if (startedAt == null) return;
    final delta = DateTime.now().difference(startedAt).inMilliseconds;
    if (delta > 0) _pendingTimeSpentMs += delta;
    _readingResumedAt = null;
  }

  int _takePendingTimeSpentMs() {
    _pauseReadingTimer();
    final ms = _pendingTimeSpentMs;
    _pendingTimeSpentMs = 0;
    _resumeReadingTimer();
    return ms;
  }


  void _applyInitialReaderSettings() {
    _fontSize = ref.read(readerFontSizeProvider);
    _lineHeight = ref.read(readerLineHeightProvider);
    _readerFontFamily = ref.read(readerFontFamilyProvider);

    // Fallback if an Arabic font is saved but the source is not Arabic
    if (!_isArabicSource &&
        const [
          'Alexandria',
          'El Messiri',
          'Lalezar',
        ].contains(_readerFontFamily)) {
      _readerFontFamily = 'System';
    }

    final box = Hive.box(HiveBox.reader);
    final bg = box.get(HiveKeys.readerCustomBg);
    final fg = box.get(HiveKeys.readerCustomText);
    if (bg is int) _readerBackground = Color(bg);
    if (fg is int) _readerText = Color(fg);
  }

  void _restoreInitialReadingPosition(String chapterUrl) {
    if (_didRestoreInitialProgress || !_scrollController.hasClients) return;
    final novelUrl = _safeDecode(widget.novelId);
    final savedPercent = ref
        .read(readerControllerProvider)
        .getSavedChapterProgressPercent(widget.sourceId, novelUrl, chapterUrl);
    _didRestoreInitialProgress = true;
    if (savedPercent <= 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final max = _scrollController.position.maxScrollExtent;
      final target = (max * (savedPercent / 100.0)).clamp(0, max).toDouble();
      _scrollController.jumpTo(target);
      _progressPercent = savedPercent;
      _progressPercentNotifier.value = savedPercent;
    });
  }

  void _persistProgress({
    bool forceComplete = false,
    bool useRepositories = true,
  }) {
    if (!useRepositories) return;
    ref
        .read(readerControllerProvider)
        .persistProgress(
          sourceId: widget.sourceId,
          novelUrl: _safeDecode(widget.novelId),
          chapterUrl: _safeDecode(widget.chapterId),
          progressPercent: _progressPercent,
          pendingTimeSpentMs: _takePendingTimeSpentMs(),
          forceComplete: forceComplete,
        );
  }


  /// Reactive listener for scroll position deltas, calculating consumption 
  /// percentage and scheduling persistence cycles.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset.clamp(0, max);
    final percent = max <= 0
        ? 0.0
        : (((offset / max) * 100).clamp(0, 100)).toDouble();
    if ((percent - _progressPercent).abs() >= 1) {
      _progressPercent = percent;
      _progressPercentNotifier.value = percent;
      _schedulePersistProgress();
    }
  }

  void _schedulePersistProgress() {
    _progressDebounce?.cancel();
    _progressDebounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _persistProgress();
    });
  }

  void _handleScrollNotification(
    ScrollNotification notification, {
    required List<SourceChapter> chapters,
    required int currentIndex,
    required bool canGoNext,
    required bool canGoPrevious,
  }) {
    if (_isNavigatingByScroll || !_scrollController.hasClients) return;
    final pos = _scrollController.position;

    if (notification is ScrollStartNotification) {
      _bottomOverscroll = 0;
      _topOverscroll = 0;
      return;
    }

    if (notification is OverscrollNotification) {
      if (pos.pixels >= pos.maxScrollExtent - 2 &&
          canGoNext &&
          notification.overscroll > 0) {
        _bottomOverscroll += notification.overscroll;
      } else if (pos.pixels <= 2 &&
          canGoPrevious &&
          notification.overscroll < 0) {
        _topOverscroll += notification.overscroll.abs();
      }
      return;
    }

    if (notification is ScrollEndNotification) {
      const hardPullThreshold = 140.0;
      if (_bottomOverscroll >= hardPullThreshold && canGoNext) {
        _persistProgress(forceComplete: true);
        _openChapter(chapters[currentIndex - 1].url);
      } else if (_topOverscroll >= hardPullThreshold && canGoPrevious) {
        _openChapter(chapters[currentIndex + 1].url);
      }
      _bottomOverscroll = 0;
      _topOverscroll = 0;
    }
  }


  Future<void> _openChapter(String url) async {
    if (_isNavigatingByScroll) return;
    final connectivity = await Connectivity().checkConnectivity();
    final isOffline = connectivity.contains(ConnectivityResult.none);
    if (isOffline) {
      final repo = ref.read(chapterRepositoryProvider);
      bool hasOffline = false;
      for (final candidate
          in ref.read(readerControllerProvider).chapterUrlVariants(url)) {
        final chapter = await repo.getChapter(candidate);
        if (chapter != null && chapter.downloaded) {
          hasOffline = true;
          break;
        }
      }
      if (!hasOffline) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Next chapter is not downloaded for offline reading'),
          ),
        );
        return;
      }
    }
    _isNavigatingByScroll = true;
    _persistProgress();
    final encodedNovelId = Uri.encodeComponent(_safeDecode(widget.novelId));
    final encodedChapterId = Uri.encodeComponent(url);
    if (!mounted) return;
    _didRestoreInitialProgress = false;
    context.pushReplacement(
      RouterConstants.reader(widget.sourceId, encodedNovelId, encodedChapterId),
    );
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _isNavigatingByScroll = false;
    });
  }


  String _safeDecode(String value) {
    try {
      return Uri.decodeComponent(value);
    } catch (_) {
      return value;
    }
  }

  String _normalizeUrl(String url) {
    final decoded = _safeDecode(url).trim();
    final parsed = Uri.tryParse(decoded);
    if (parsed == null) {
      return decoded.replaceAll(_trailingSlashRx, '');
    }
    final normalized = parsed.replace(query: null, fragment: null).toString();
    return normalized.trim().replaceAll(_trailingSlashRx, '');
  }

  bool _isSameChapterUrl(String a, String b) {
    final aVariants = ref
        .read(readerControllerProvider)
        .chapterUrlVariants(a)
        .map(_normalizeUrl)
        .toSet();
    final bVariants = ref
        .read(readerControllerProvider)
        .chapterUrlVariants(b)
        .map(_normalizeUrl)
        .toSet();
    if (aVariants.any(bVariants.contains)) return true;
    final na = _normalizeUrl(a);
    final nb = _normalizeUrl(b);
    if (na == nb) return true;
    final an = _chapterNumberRx.firstMatch(na)?.group(1);
    final bn = _chapterNumberRx.firstMatch(nb)?.group(1);
    if (an != null && bn != null && an == bn) {
      final aPrefix = na.replaceFirst(RegExp(r'/\d+(?:/)?$'), '');
      final bPrefix = nb.replaceFirst(RegExp(r'/\d+(?:/)?$'), '');
      return aPrefix == bPrefix;
    }
    return false;
  }

  int? _extractChapterNumber(String url) {
    final normalized = _normalizeUrl(url);
    final match = _chapterNumberRx.firstMatch(normalized);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  String _chapterTitleFromUrl(String chapterUrl) {
    final m = _chapterNumberRx.firstMatch(chapterUrl);
    if (m != null) return 'Chapter ${m.group(1)}';
    return chapterUrl;
  }

  /// Performs a high-fidelity lookup for the current segment index within 
  /// the source catalog.
  /// 
  /// Employs a multi-stage resolution strategy:
  /// 1. Canonical URL permutation matching.
  /// 2. Numerical index extraction fallback for resilient cross-source mapping.
  int _findCurrentChapterIndex(
    List<SourceChapter> chapters,
    String chapterUrl,
  ) {
    for (var i = 0; i < chapters.length; i++) {
      if (_isSameChapterUrl(chapters[i].url, chapterUrl)) return i;
    }
    final targetNumber = _extractChapterNumber(chapterUrl);
    if (targetNumber != null) {
      for (var i = 0; i < chapters.length; i++) {
        final n = chapters[i].number;
        if (n != null && n.toInt() == targetNumber) return i;
      }
    }
    return -1;
  }

  /// Triggers async paragraph parsing on a background isolate if the HTML
  /// content identity has changed. For small content, parsing happens
  /// synchronously to avoid isolate spawn overhead.
  void _ensureParagraphsParsed(String html) {
    if (_cachedHtmlForParagraphs == html) return;
    _cachedHtmlForParagraphs = html;
    _resolvedParagraphs = null;
    _paragraphsFuture = parseHtmlToParagraphsAsync(html).then((result) {
      _resolvedParagraphs = result;
      return result;
    });
  }
}
