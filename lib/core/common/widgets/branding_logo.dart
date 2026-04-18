import 'package:flutter/material.dart';

/// A theme-aware branding component that renders the application logo
/// and automatically applies a color filter derived from the current 
/// primary theme color.
class BrandingLogo extends StatelessWidget {
  /// The dimension (width/height) of the logo. Defaults to 48.
  final double size;

  /// Optional color override. If null, uses the theme's primary color.
  final Color? color;

  const BrandingLogo({
    super.key,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? Theme.of(context).colorScheme.primary;

    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: logoColor,
      // Fallback for cases where the image might be missing
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.auto_stories_rounded,
        size: size * 0.8,
        color: logoColor.withValues(alpha: 0.5),
      ),
    );
  }
}
