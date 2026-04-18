import 'package:flutter/foundation.dart';

/// Pre-compiled regular expressions for HTML paragraph decomposition.
/// Compiled once as top-level constants to avoid per-call RegExp allocation.
final RegExp _brTagPattern = RegExp(r'<br\s*/?>', caseSensitive: false);
final RegExp _blockClosePattern = RegExp(
  r'</(p|div|section|article|blockquote|li|h[1-6])>',
  caseSensitive: false,
);
final RegExp _doubleNewlinePattern = RegExp(r'\n{2,}');
final RegExp _htmlTagPattern = RegExp(r'<[^>]+>');
final RegExp _contentCheckPattern = RegExp(
  r'[A-Za-z0-9\u0600-\u06FF\u0750-\u077F]',
);

/// Decomposes raw HTML content into a structured collection of semantic
/// paragraph fragments, ensuring formatting tags are preserved within
/// each chunk.
///
/// This is a top-level function so it can be used with [compute] for
/// isolate-based execution, offloading the regex-heavy work off the UI thread.
List<String> parseHtmlToParagraphs(String html) {
  var text = html;
  text = text.replaceAll(_brTagPattern, '\n');
  text = text.replaceAll(_blockClosePattern, '\n\n');

  final chunks = text
      .split(_doubleNewlinePattern)
      .map((e) => e.trim())
      .where(
        (e) =>
            e.isNotEmpty &&
            _contentCheckPattern.hasMatch(e.replaceAll(_htmlTagPattern, '')),
      )
      .toList(growable: false);
  return chunks;
}

Future<List<String>> parseHtmlToParagraphsAsync(String html) async {
  final hash = html.hashCode;
  // 500k characters is roughly 100,000 words. Parsing this synchronously
  // guarantees zero Skeleton flashes for downloaded/cached chapters.
  // The regex is highly optimized so the ~15ms UI block is completely unnoticeable.
  if (html.length < 500000) {
    return parseHtmlToParagraphsSyncAndCache(html);
  }

  final result = await compute(parseHtmlToParagraphs, html);
  _addToCache(hash, result);
  return result;
}

/// Parses HTML instantly on the main thread and caches it.
/// Use this when you absolutely must bypass FutureBuilder to prevent UI flickering.
List<String> parseHtmlToParagraphsSyncAndCache(String html) {
  final hash = html.hashCode;
  final cached = _parsedParagraphCache[hash];
  if (cached != null) return cached;

  final result = parseHtmlToParagraphs(html);
  _addToCache(hash, result);
  return result;
}

final Map<int, List<String>> _parsedParagraphCache = {};

void _addToCache(int hash, List<String> paragraphs) {
  if (_parsedParagraphCache.length >= 20) {
    _parsedParagraphCache.remove(_parsedParagraphCache.keys.first);
  }
  _parsedParagraphCache[hash] = paragraphs;
}

/// Synchronously checks if the paragraphs for the given HTML are already parsed and cached.
/// This enables instant loading (zero frame drops) when revisiting chapters.
List<String>? getCachedParagraphsSynchronous(String html) {
  return _parsedParagraphCache[html.hashCode];
}
