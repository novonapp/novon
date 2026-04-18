import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/novon_colors.dart';
import 'inline_shimmer_line.dart';

/// Dedicated sliver surface responsible for rendering the narrative summary, 
/// featuring interactive expansion orchestration for long-form textual content.
class NovelDescriptionSection extends StatelessWidget {
  final AsyncValue<dynamic> detail;
  final bool expanded;
  final VoidCallback onToggle;

  const NovelDescriptionSection({
    super.key,
    required this.detail,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            detail.when(
              loading: () => const InlineShimmerLine(width: 280, height: 60),
              error: (e, st) => Text(
                'No description available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: NovonColors.textSecondary,
                ),
              ),
              data: (d) {
                final desc = (d.description ?? '').trim();
                if (desc.isEmpty) {
                  return Text(
                    'No description available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NovonColors.textSecondary,
                    ),
                  );
                }
                return GestureDetector(
                  onTap: onToggle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        desc,
                        maxLines: expanded ? null : 4,
                        overflow: expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: NovonColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        expanded ? 'Show less' : 'Tap to expand',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: NovonColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
