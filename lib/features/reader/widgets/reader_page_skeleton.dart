import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/novon_colors.dart';

/// Skeleton shimmer placeholder shown while chapter content is loading.
class ReaderPageSkeleton extends StatelessWidget {
  const ReaderPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: NovonColors.shimmerBase,
      highlightColor: NovonColors.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          18,
          (i) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 14,
            width: i % 3 == 0 ? double.infinity : (i % 3 == 1 ? 260 : 220),
            decoration: BoxDecoration(
              color: NovonColors.shimmerBase,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
