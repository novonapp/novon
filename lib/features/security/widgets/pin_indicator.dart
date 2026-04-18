import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

/// A visual feedback component representing the current state and progress 
/// of a secure identifier entry sequence.
class PinIndicator extends StatelessWidget {
  final int length;
  final int currentLength;
  final bool isError;

  const PinIndicator({
    super.key,
    required this.length,
    required this.currentLength,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final bool isActive = index < currentLength;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isError
                ? NovonColors.error
                : isActive
                    ? NovonColors.primary
                    : NovonColors.surfaceVariant,
            border: Border.all(
              color: isActive ? NovonColors.primary : NovonColors.border,
              width: 1.5,
            ),
            boxShadow: isActive && !isError
                ? [
                    BoxShadow(
                      color: NovonColors.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
