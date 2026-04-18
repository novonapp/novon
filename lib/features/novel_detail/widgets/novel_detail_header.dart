import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/widgets/novel_cover_image.dart';
import 'status_badge.dart';
import 'inline_shimmer_line.dart';

/// An expandable SliverAppBar-based header providing primary visual context,
/// including cover imagery, hierarchical metadata, and status indicators.
class NovelDetailHeader extends StatelessWidget {
  final AsyncValue<dynamic> detail;
  final String? headerCoverUrl;
  final String? initialTitle;
  final String sourceId;
  final VoidCallback onWebView;

  const NovelDetailHeader({
    super.key,
    required this.detail,
    required this.headerCoverUrl,
    required this.initialTitle,
    required this.sourceId,
    required this.onWebView,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      actions: [
        IconButton(
          tooltip: 'Open in WebView (save cookies)',
          icon: const Icon(Icons.public_rounded),
          onPressed: onWebView,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: .3,
              child: NovelCoverImage(
                imageUrl: headerCoverUrl,
                width: double.infinity,
                height: double.infinity,
                borderRadius: 0,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    NovonColors.primary.withValues(alpha: 0.3),
                    NovonColors.background,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  NovelCoverImage(
                    imageUrl: headerCoverUrl,
                    width: 110,
                    height: 160,
                    borderRadius: 10,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTitle(context),
                        const SizedBox(height: 6),
                        _buildAuthor(context),
                        const SizedBox(height: 4),
                        _buildStatusRow(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return detail.when(
      loading: () => const InlineShimmerLine(width: 220, height: 18),
      error: (_, _) => Text(
        'Failed to load',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: NovonColors.textPrimary),
      ),
      data: (d) => Text(
        d.title.isEmpty ? (initialTitle ?? 'Unknown') : d.title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: NovonColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildAuthor(BuildContext context) {
    return detail.when(
      loading: () => const InlineShimmerLine(width: 140),
      error: (_, _) => const SizedBox.shrink(),
      data: (d) => Text(
        d.author ?? '',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: NovonColors.primary),
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    return Row(
      children: [
        detail.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (d) => StatusBadge(
            status: (d.status ?? 'unknown').toString(),
            color: NovonColors.ongoing,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '• $sourceId',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: NovonColors.textTertiary),
        ),
      ],
    );
  }
}
