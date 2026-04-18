import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

/// A specialized UI placeholder providing non-blocking visual feedback during
/// asynchronous metadata resolution.
class InlineShimmerLine extends StatelessWidget {
  final double width;
  final double height;
  const InlineShimmerLine({super.key, required this.width, this.height = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: NovonColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
