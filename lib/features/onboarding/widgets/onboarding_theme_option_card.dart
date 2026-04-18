import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

/// Theme option card for Light/Dark/System selection.
class OnboardingThemeOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const OnboardingThemeOptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? NovonColors.primary.withValues(alpha: 0.17)
              : NovonColors.surfaceVariant.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? NovonColors.primary
                : NovonColors.border.withValues(alpha: 0.32),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? NovonColors.primary : null),
            const SizedBox(height: 6),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
