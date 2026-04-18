import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

/// Permission request tile with icon, text, and grant button.
class OnboardingPermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool granted;
  final String buttonLabel;
  final VoidCallback? onPressed;

  const OnboardingPermissionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NovonColors.surfaceVariant.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: granted
              ? NovonColors.success.withValues(alpha: 0.45)
              : NovonColors.border.withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: granted ? NovonColors.success : NovonColors.textPrimary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: NovonColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: granted
                  ? NovonColors.success
                  : NovonColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
