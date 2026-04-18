import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

class ReaderSettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const ReaderSettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NovonColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NovonColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: NovonColors.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: NovonColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: NovonColors.surface.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: NovonColors.border.withValues(alpha: 0.22),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
