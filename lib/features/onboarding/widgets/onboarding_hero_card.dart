import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

/// A centered card with subtle border used on hero sections.
class OnboardingHeroCard extends StatelessWidget {
  final Widget child;

  const OnboardingHeroCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NovonColors.surfaceVariant.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NovonColors.border.withValues(alpha: 0.35)),
      ),
      child: child,
    );
  }
}
