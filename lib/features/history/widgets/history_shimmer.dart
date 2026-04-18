import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/novon_colors.dart';

/// A specialized sliver-safe loading skeleton for the history screen.
/// 
/// Uses a Column instead of a ListView to support intrinsic measurement 
/// within SliverFillRemaining contexts.
class HistoryShimmer extends StatelessWidget {
  final int itemCount;

  const HistoryShimmer({super.key, this.itemCount = 12});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          for (var i = 0; i < itemCount; i++) ...[
            _buildCoverItem(),
            if (i < itemCount - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  Widget _buildCoverItem() {
    return Shimmer.fromColors(
      baseColor: NovonColors.shimmerBase,
      highlightColor: NovonColors.shimmerHighlight,
      child: ListTile(
        leading: Container(
          width: 42,
          height: 56,
          decoration: BoxDecoration(
            color: NovonColors.shimmerBase,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Container(
          height: 12,
          decoration: BoxDecoration(
            color: NovonColors.shimmerHighlight,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            height: 10,
            width: 160,
            decoration: BoxDecoration(
              color: NovonColors.shimmerHighlight,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }
}
