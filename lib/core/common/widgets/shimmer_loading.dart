import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/novon_colors.dart';

/// Foundational UI component for rendering animated skeleton placeholders
/// during asynchronous data acquisition.
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: NovonColors.shimmerBase,
      highlightColor: NovonColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: NovonColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A specialized grid orchestration layer for rendering animated skeleton
/// placeholders for novel content indices.
class NovelGridShimmer extends StatelessWidget {
  final int itemCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;
  final int crossAxisCount;

  const NovelGridShimmer({
    super.key,
    this.itemCount = 12,
    this.childAspectRatio = 0.47,
    this.padding = const EdgeInsets.all(16),
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: NovonColors.shimmerBase,
          highlightColor: NovonColors.shimmerHighlight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: NovonColors.shimmerBase,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: NovonColors.shimmerBase,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 10,
                width: 60,
                decoration: BoxDecoration(
                  color: NovonColors.shimmerBase,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A specialized list orchestration layer for rendering animated skeleton
/// placeholders for chapter metadata segments.
class ChapterListShimmer extends StatelessWidget {
  final int itemCount;

  const ChapterListShimmer({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: NovonColors.shimmerBase,
          highlightColor: NovonColors.shimmerHighlight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            decoration: BoxDecoration(
              color: NovonColors.shimmerBase,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: NovonColors.shimmerHighlight.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: NovonColors.shimmerHighlight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 120,
                        decoration: BoxDecoration(
                          color: NovonColors.shimmerHighlight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: NovonColors.shimmerHighlight,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A specialized list orchestration layer for rendering animated skeleton
/// placeholders for novel cover assets.
class CoverListShimmer extends StatelessWidget {
  final int itemCount;

  const CoverListShimmer({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
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
      },
    );
  }
}

/// A specialized list orchestration layer for rendering animated skeleton
/// placeholders for extension source indices.
class ExtensionListShimmer extends StatelessWidget {
  final int itemCount;

  const ExtensionListShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: NovonColors.shimmerBase,
          highlightColor: NovonColors.shimmerHighlight,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NovonColors.shimmerBase,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: NovonColors.shimmerHighlight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 130,
                        decoration: BoxDecoration(
                          color: NovonColors.shimmerHighlight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 90,
                        decoration: BoxDecoration(
                          color: NovonColors.shimmerHighlight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A specialized grid orchestration layer for rendering animated skeleton
/// placeholders for diagnostic and usage statistics.
class StatsGridShimmer extends StatelessWidget {
  const StatsGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: NovonColors.shimmerBase,
          highlightColor: NovonColors.shimmerHighlight,
          child: Container(
            decoration: BoxDecoration(
              color: NovonColors.shimmerBase,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
