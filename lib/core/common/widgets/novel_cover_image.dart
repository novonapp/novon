import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../theme/novon_colors.dart';

/// A polymorphic image rendering component capable of orchestrating asset 
/// acquisition from localized file systems or remote network repositories.
///
/// Implements automated detection of localized paths and provides fallback 
/// orchestration via [CachedNetworkImage] for remote resources.
class NovelCoverImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const NovelCoverImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _placeholder();
    }

    final url = imageUrl!.trim();
    if (url.isEmpty) return _placeholder();

    // Orchestrates retrieval from localized filesystem storage.
    if (url.startsWith('/')) {
      final file = File(url);
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, _, _) => _placeholder(),
        ),
      );
    }

    // Orchestrates retrieval from remote repositories via authenticated cache layer.
    final normalizedUrl = _normalizeImageUrl(url);
    if (normalizedUrl.isEmpty) return _placeholder();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: normalizedUrl,
        cacheKey: normalizedUrl,
        useOldImageOnUrlChange: true,
        fadeInDuration: Duration.zero,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _placeholder(),
        errorWidget: (context, url, error) => _placeholder(),
      ),
    );
  }

  /// Performs sanitization and normalization of remote URIs to ensure 
  /// consistent retrieval patterns across varied source architectures.
  String _normalizeImageUrl(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return '';
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return trimmed;
    if (!uri.hasScheme) return trimmed;
    final encodedPath = uri.pathSegments
        .map((segment) => Uri.encodeComponent(_safeDecode(segment)))
        .join('/');
    final normalized = uri.replace(
      path: encodedPath.isEmpty ? uri.path : '/$encodedPath',
    );
    return normalized.toString();
  }

  String _safeDecode(String input) {
    try {
      return Uri.decodeComponent(input);
    } catch (_) {
      return input;
    }
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: NovonColors.surfaceVariant,
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [NovonColors.surfaceVariant, NovonColors.surfaceElevated],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: NovonColors.textTertiary,
          size: 32,
        ),
      ),
    );
  }
}
