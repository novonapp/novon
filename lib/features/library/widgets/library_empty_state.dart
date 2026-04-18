import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/novon_colors.dart';

/// Specialized placeholder surface rendered when the localized library 
/// collection is devoid of entities, orchestrating a clear navigational 
/// path for content discovery and acquisition.
class LibraryEmptyState extends StatelessWidget {
  const LibraryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    NovonColors.primary.withValues(alpha: 0.15),
                    NovonColors.accent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.collections_bookmark_rounded,
                color: NovonColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your library is empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: NovonColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse sources to discover novels\nand add them to your library',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: NovonColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.go('/browse'),
              icon: const Icon(Icons.explore_rounded, size: 18),
              label: const Text('Browse Sources'),
              style: FilledButton.styleFrom(
                backgroundColor: NovonColors.primary,
                foregroundColor: NovonColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
