import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../common/models/extension_manifest.dart';
import '../services/extension_engine.dart';
import '../services/storage_path_service.dart';
import '../common/models/chapter.dart' as m;
import 'db_providers.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// Pre-compiled regular expressions cached at the module level to avoid
/// redundant per-call allocation during high-frequency chapter iteration.
final RegExp _trailingSlashRx = RegExp(r'/+$');
final RegExp _chapterNumberRx = RegExp(r'(\d+)(?:/)?$');
final RegExp _leadingPunctuationRx = RegExp(r'^[\.\u2026\s\-_\u2013\u2014:]+');

class SourceNovel {
  final String title;
  final String url;
  final String coverUrl;

  const SourceNovel({
    required this.title,
    required this.url,
    required this.coverUrl,
  });
}

class SourceLatestResult {
  final List<SourceNovel> novels;
  final bool hasNextPage;

  const SourceLatestResult({required this.novels, required this.hasNextPage});
}

class SourceNovelDetail {
  final String title;
  final String? author;
  final String? description;
  final String? status;
  final List<String> genres;
  final String? coverUrl;

  const SourceNovelDetail({
    required this.title,
    this.author,
    this.description,
    this.status,
    this.genres = const [],
    this.coverUrl,
  });
}

class SourceChapter {
  final String name;
  final String url;
  final num? number;

  const SourceChapter({required this.name, required this.url, this.number});
}

class SourceChapterContent {
  final String html;
  final String? title;
  const SourceChapterContent({required this.html, this.title});
}

String _chapterCacheKey(String sourceId, String chapterUrl) {
  final normalized = chapterUrl.trim().replaceAll(_trailingSlashRx, '');
  return '$sourceId|$normalized';
}

final Map<String, String> _sessionChapterHtmlCache = <String, String>{};

String _sanitizeChapterHtmlGeneric(String html) {
  // Keep Flutter-side processing neutral. Source scripts should return
  // already-clean chapter HTML.
  return html.trim();
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
  final withoutSlash = trimmed.replaceAll(_trailingSlashRx, '');
  if (withoutSlash.isNotEmpty) variants.add(withoutSlash);
  final decoded = _safeDecodeUrl(trimmed);
  if (decoded.isNotEmpty) variants.add(decoded);
  final decodedNoSlash = decoded.replaceAll(_trailingSlashRx, '');
  if (decodedNoSlash.isNotEmpty) variants.add(decodedNoSlash);
  final encoded = Uri.encodeFull(
    decodedNoSlash.isNotEmpty ? decodedNoSlash : decoded,
  );
  if (encoded.isNotEmpty) variants.add(encoded);
  final encodedNoSlash = encoded.replaceAll(_trailingSlashRx, '');
  if (encodedNoSlash.isNotEmpty) variants.add(encodedNoSlash);
  return variants.toList();
}

Uri _parseBase(String baseUrl) {
  final uri = Uri.tryParse(baseUrl);
  return uri ?? Uri();
}

String _resolveUrl(Uri base, Object? raw) {
  final s = (raw ?? '').toString().trim();
  if (s.isEmpty) return '';
  final u = Uri.tryParse(s);
  if (u != null && u.hasScheme) return u.toString();
  try {
    return base.resolve(s).toString();
  } catch (_) {
    return s;
  }
}

num? _extractChapterNumber(String url, Object? rawNumber) {
  if (rawNumber is num) return rawNumber;
  final m = _chapterNumberRx.firstMatch(url);
  if (m != null) {
    return num.tryParse(m.group(1)!);
  }
  return null;
}

String _normalizeChapterName(String name, String url, num? number) {
  final trimmed = name.trim();
  if (trimmed.isNotEmpty) {
    final cleaned = trimmed.replaceFirst(_leadingPunctuationRx, '').trim();
    if (cleaned.isNotEmpty && cleaned != '…' && cleaned != '...') {
      return cleaned;
    }
  }
  if (number != null) return 'Chapter $number';
  final m = _chapterNumberRx.firstMatch(url);
  if (m != null) return 'Chapter ${m.group(1)}';
  return 'Chapter';
}

String _withPageQuery(String novelUrl, int page) {
  final uri = Uri.tryParse(novelUrl);
  if (uri == null) return novelUrl;
  final q = Map<String, String>.from(uri.queryParameters);
  q['page'] = '$page';
  return uri.replace(queryParameters: q).toString();
}

Future<T> _retryWithBackoff<T>(
  Future<T> Function() run, {
  int attempts = 3,
  Duration initialDelay = const Duration(milliseconds: 350),
}) async {
  Object? lastError;
  var delay = initialDelay;
  for (var i = 0; i < attempts; i++) {
    try {
      return await run();
    } catch (e) {
      final message = e.toString().toLowerCase();
      // 4xx (especially 404 on paged browse endpoints) is usually non-retriable.
      if (message.contains('status code of 404') ||
          message.contains('statuscode: 404') ||
          message.contains('badresponse') && message.contains('404')) {
        rethrow;
      }
      lastError = e;
      if (i == attempts - 1) break;
      await Future.delayed(delay);
      delay *= 2;
    }
  }
  throw lastError ?? Exception('Unknown fetch failure');
}

Future<(ExtensionManifest manifest, String scriptSource)>
_loadManifestAndSource(String sourceId) async {
  final storagePath = StoragePathService.instance.storagePath;
  if (storagePath == null) {
    throw Exception('Storage path not configured');
  }

  final baseDir = '$storagePath/extensions/$sourceId';
  final manifestFile = File('$baseDir/manifest.json');
  final sourceFile = File('$baseDir/source.js');

  if (!await manifestFile.exists()) {
    throw Exception('Extension manifest.json not found');
  }
  if (!await sourceFile.exists()) {
    throw Exception('Extension source.js not found');
  }

  final manifestJson =
      jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
  final manifest = ExtensionManifest.fromJson(manifestJson);
  final source = await sourceFile.readAsString();
  return (manifest, source);
}

final sourceLatestProvider =
    AsyncNotifierProviderFamily<
      _SourceLatestNotifier,
      SourceLatestResult,
      String
    >(() => _SourceLatestNotifier());

class _SourceLatestNotifier
    extends FamilyAsyncNotifier<SourceLatestResult, String> {
  final Map<String, SourceNovel> _merged = {};
  int _currentPage = 0;
  bool _hasNextPage = true;
  bool _loadingMore = false;

  Future<SourceLatestResult> _fetchPage({
    required String sourceId,
    required int page,
  }) async {
    final (manifest, scriptSource) = await _loadManifestAndSource(sourceId);
    final base = _parseBase(manifest.baseUrl);
    try {
      final raw = await _retryWithBackoff(
        () => ExtensionEngine.instance.fetchLatestUpdates(
          sourceId,
          scriptSource,
          page,
        ),
      );
      final map = Map<String, dynamic>.from(raw as Map);
      final rawNovels = List<Map<String, dynamic>>.from(
        map['novels'] ?? const [],
      );
      final novels = rawNovels
          .map(
            (n) => SourceNovel(
              title: (n['title'] ?? 'Unknown').toString(),
              url: _resolveUrl(base, n['url']),
              coverUrl: _resolveUrl(base, n['coverUrl']),
            ),
          )
          .where((n) => n.url.isNotEmpty)
          .toList(growable: false);
      return SourceLatestResult(
        novels: novels,
        hasNextPage: map['hasNextPage'] == true,
      );
    } catch (_) {
      return const SourceLatestResult(novels: [], hasNextPage: false);
    }
  }

  @override
  Future<SourceLatestResult> build(String sourceId) async {
    ref.keepAlive(); // keep cache so re-entering source doesn't auto-refetch
    _merged.clear();
    _currentPage = 0;
    _hasNextPage = true;
    final first = await _fetchPage(sourceId: sourceId, page: 1);
    _currentPage = 1;
    _hasNextPage = first.hasNextPage;
    for (final n in first.novels) {
      _merged[n.url] = n;
    }
    return SourceLatestResult(
      novels: _merged.values.toList(growable: false),
      hasNextPage: _hasNextPage,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => build(arg));
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasNextPage) return;
    _loadingMore = true;
    try {
      final nextPage = _currentPage + 1;
      final result = await _fetchPage(sourceId: arg, page: nextPage);
      _currentPage = nextPage;
      _hasNextPage = result.hasNextPage && result.novels.isNotEmpty;
      for (final n in result.novels) {
        _merged[n.url] = n;
      }
      state = AsyncData(
        SourceLatestResult(
          novels: _merged.values.toList(growable: false),
          hasNextPage: _hasNextPage,
        ),
      );
    } finally {
      _loadingMore = false;
    }
  }
}

final sourceSearchProvider = FutureProvider.family
    .autoDispose<List<SourceNovel>, ({String sourceId, String query})>((
      ref,
      params,
    ) async {
      final (manifest, scriptSource) = await _loadManifestAndSource(
        params.sourceId,
      );
      final base = _parseBase(manifest.baseUrl);

      final raw = await _retryWithBackoff(
        () => ExtensionEngine.instance.search(
          params.sourceId,
          scriptSource,
          params.query,
          1,
        ),
      );

      final map = Map<String, dynamic>.from(raw as Map);
      final rawNovels = List<Map<String, dynamic>>.from(
        map['novels'] ?? const [],
      );
      return rawNovels
          .map(
            (n) => SourceNovel(
              title: (n['title'] ?? 'Unknown').toString(),
              url: _resolveUrl(base, n['url']),
              coverUrl: _resolveUrl(base, n['coverUrl']),
            ),
          )
          .where((n) => n.url.isNotEmpty)
          .toList(growable: false);
    });

final sourceNovelDetailProvider =
    FutureProvider.family<
      SourceNovelDetail,
      ({String sourceId, String novelUrl})
    >((ref, params) async {
      final (manifest, scriptSource) = await _loadManifestAndSource(
        params.sourceId,
      );
      final base = _parseBase(manifest.baseUrl);

      final raw = await _retryWithBackoff(
        () => ExtensionEngine.instance.fetchNovelDetail(
          params.sourceId,
          scriptSource,
          params.novelUrl,
        ),
      );

      final map = Map<String, dynamic>.from(raw as Map);
      return SourceNovelDetail(
        title: (map['title'] ?? 'Unknown').toString(),
        author: map['author']?.toString(),
        description: map['description']?.toString(),
        status: map['status']?.toString(),
        genres: (map['genres'] is List)
            ? (map['genres'] as List).map((e) => e.toString()).toList()
            : const [],
        coverUrl: _resolveUrl(base, map['coverUrl']),
      );
    });

final sourceChapterListProvider =
    FutureProvider.family<
      List<SourceChapter>,
      ({String sourceId, String novelUrl})
    >((ref, params) async {
      final (manifest, scriptSource) = await _loadManifestAndSource(
        params.sourceId,
      );
      final base = _parseBase(manifest.baseUrl);

      Future<List<SourceChapter>> fetchFrom(String targetUrl) async {
        try {
          final raw = await _retryWithBackoff(
            () => ExtensionEngine.instance.fetchChapterList(
              params.sourceId,
              scriptSource,
              targetUrl,
            ),
          );
          final list = List<Map<String, dynamic>>.from(raw as List);
          return list
              .map((c) {
                final resolvedUrl = _resolveUrl(base, c['url']);
                final parsedNumber = _extractChapterNumber(
                  resolvedUrl,
                  c['number'],
                );
                return SourceChapter(
                  name: _normalizeChapterName(
                    (c['name'] ?? '').toString(),
                    resolvedUrl,
                    parsedNumber,
                  ),
                  url: resolvedUrl,
                  number: parsedNumber,
                );
              })
              .where((c) => c.url.isNotEmpty)
              .toList();
        } catch (_) {
          return const <SourceChapter>[];
        }
      }

      final merged = <String, SourceChapter>{};
      void addAll(List<SourceChapter> list) {
        for (final chapter in list) {
          merged.putIfAbsent(chapter.url, () => chapter);
        }
      }

      final firstPage = await fetchFrom(params.novelUrl);
      addAll(firstPage);

      // Offline fallback: If we can't get chapters from the web, try the local database.
      if (merged.isEmpty) {
        final repo = ref.read(chapterRepositoryProvider);
        final localChapters = await repo.getChaptersForNovel(params.novelUrl);
        if (localChapters.isNotEmpty) {
          final mapped = localChapters
              .map(
                (c) => SourceChapter(
                  name: c.name,
                  url: c.url,
                  number: c.number == -1 ? null : c.number,
                ),
              )
              .toList();
          // Ensure descending order by number for consistency
          mapped.sort((a, b) {
            final an = a.number;
            final bn = b.number;
            if (an == null && bn == null) return 0;
            if (an == null) return 1;
            if (bn == null) return -1;
            return bn.compareTo(an);
          });
          return mapped;
        }
      }

      if (firstPage.length > 200) {
        final chapters = merged.values.toList();
        chapters.sort((a, b) {
          final an = a.number;
          final bn = b.number;
          if (an == null && bn == null) return 0;
          if (an == null) return 1;
          if (bn == null) return -1;
          return bn.compareTo(an);
        });
        return chapters;
      }

      final firstPageUrls = firstPage.map((c) => c.url).toSet();

      // Some sources only return a subset on the first page.
      // Probe query pagination and merge unique chapters.
      const maxPageProbe = 40;
      for (var page = 2; page <= maxPageProbe; page += 4) {
        final pages = <int>[
          page,
          page + 1,
          page + 2,
          page + 3,
        ].where((p) => p <= maxPageProbe).toList();
        final batch = await Future.wait(
          pages.map((p) => fetchFrom(_withPageQuery(params.novelUrl, p))),
        );
        var shouldBreak = false;
        for (final queryPage in batch) {
          if (queryPage.isEmpty) {
            shouldBreak = true;
            break;
          }
          final queryUrls = queryPage.map((c) => c.url).toSet();
          if (queryUrls.isNotEmpty &&
              queryUrls.length == firstPageUrls.length) {
            var allSame = true;
            for (final url in queryUrls) {
              if (!firstPageUrls.contains(url)) {
                allSame = false;
                break;
              }
            }
            if (allSame) {
              shouldBreak = true;
              break;
            }
          }

          final beforeQuery = merged.length;
          addAll(queryPage);
          if (merged.length == beforeQuery) {
            shouldBreak = true;
            break;
          }
        }
        if (shouldBreak) break;
      }

      final chapters = merged.values.toList();

      // ensure descending by number if provided
      chapters.sort((a, b) {
        final an = a.number;
        final bn = b.number;
        if (an == null && bn == null) return 0;
        if (an == null) return 1;
        if (bn == null) return -1;
        return bn.compareTo(an);
      });

      return chapters;
    });

final sourceChapterContentProvider = FutureProvider.family
    .autoDispose<SourceChapterContent, ({String sourceId, String chapterUrl})>((
      ref,
      params,
    ) async {
      final chapterRepo = ref.read(chapterRepositoryProvider);
      final urlVariants = _chapterUrlVariants(params.chapterUrl);
      for (final candidateUrl in urlVariants) {
        final sessionHit =
            _sessionChapterHtmlCache[_chapterCacheKey(
              params.sourceId,
              candidateUrl,
            )];
        if (sessionHit != null && sessionHit.isNotEmpty) {
          return SourceChapterContent(
            html: _sanitizeChapterHtmlGeneric(sessionHit),
          );
        }
      }
      // 1. Check DB (resilient variant lookup inside the repo)
      final dbCached = await chapterRepo.getChapterContent(params.chapterUrl);
      if (dbCached != null && dbCached.html.isNotEmpty) {
        _sessionChapterHtmlCache[_chapterCacheKey(
              params.sourceId,
              params.chapterUrl,
            )] =
            dbCached.html;
        return SourceChapterContent(
          html: _sanitizeChapterHtmlGeneric(dbCached.html),
          title: dbCached.title,
        );
      }

      // 2. Fallback to Hive with full variant check
      final box = Hive.box(HiveBox.app);
      final rawCache = box.get(HiveKeys.chapterHtmlCache);
      final cached = rawCache is Map
          ? Map<String, dynamic>.from(rawCache)
          : <String, dynamic>{};

      for (final candidateUrl in urlVariants) {
        final hit = cached[_chapterCacheKey(params.sourceId, candidateUrl)];
        if (hit is Map) {
          final map = Map<String, dynamic>.from(hit);
          final html = (map['html'] ?? '').toString();
          if (html.isNotEmpty) {
            _sessionChapterHtmlCache[_chapterCacheKey(
                  params.sourceId,
                  candidateUrl,
                )] =
                html;
            return SourceChapterContent(
              html: _sanitizeChapterHtmlGeneric(html),
            );
          }
        }
      }

      final (_, scriptSource) = await _loadManifestAndSource(params.sourceId);

      try {
        final raw = await _retryWithBackoff(
          () => ExtensionEngine.instance.fetchChapterContent(
            params.sourceId,
            scriptSource,
            params.chapterUrl,
          ),
        );

        if (raw is Map) {
          final map = Map<String, dynamic>.from(raw);
          final html = _sanitizeChapterHtmlGeneric(
            (map['html'] ?? '').toString(),
          );
          if (html.isNotEmpty) {
            for (final candidateUrl in urlVariants) {
              cached[_chapterCacheKey(params.sourceId, candidateUrl)] = {
                'html': html,
                'savedAt': DateTime.now().toIso8601String(),
              };
              _sessionChapterHtmlCache[_chapterCacheKey(
                    params.sourceId,
                    candidateUrl,
                  )] =
                  html;
            }
            await box.put(HiveKeys.chapterHtmlCache, cached);
            await chapterRepo.cacheChapterContent(
              m.ChapterContent(
                chapterId: urlVariants.first,
                html: html,
                fetchedAt: DateTime.now(),
              ),
            );
          }
          return SourceChapterContent(html: html);
        }

        final html = _sanitizeChapterHtmlGeneric(raw?.toString() ?? '');
        if (html.isNotEmpty) {
          for (final candidateUrl in urlVariants) {
            cached[_chapterCacheKey(params.sourceId, candidateUrl)] = {
              'html': html,
              'savedAt': DateTime.now().toIso8601String(),
            };
            _sessionChapterHtmlCache[_chapterCacheKey(
                  params.sourceId,
                  candidateUrl,
                )] =
                html;
          }
          await box.put(HiveKeys.chapterHtmlCache, cached);
          await chapterRepo.cacheChapterContent(
            m.ChapterContent(
              chapterId: urlVariants.first,
              html: html,
              fetchedAt: DateTime.now(),
            ),
          );
        }
        return SourceChapterContent(html: html);
      } catch (_) {
        rethrow;
      }
    });
