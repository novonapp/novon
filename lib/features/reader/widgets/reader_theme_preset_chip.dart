import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

class ReaderThemePresetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ReaderThemePresetChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: NovonColors.primary.withValues(alpha: 0.2),
      side: BorderSide(
        color: selected
            ? NovonColors.primary
            : NovonColors.textSecondary.withValues(alpha: 0.3),
      ),
      labelStyle: TextStyle(
        color: selected ? NovonColors.primary : NovonColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: NovonColors.surface,
    );
  }
}
