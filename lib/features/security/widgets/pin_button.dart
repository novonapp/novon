import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/novon_colors.dart';

class PinButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isTransparent;

  const PinButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled
            ? () {
                HapticFeedback.lightImpact();
                onPressed!();
              }
            : null,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isTransparent || !isEnabled
                ? Colors.transparent
                : NovonColors.surfaceVariant.withValues(alpha: 0.5),
            border: !isTransparent && isEnabled
                ? Border.all(
                    color: NovonColors.border.withValues(alpha: 0.3),
                    width: 1.5)
                : null,
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: NovonColors.textPrimary, size: 28)
                : Text(
                    label,
                    style: TextStyle(
                      color: NovonColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
