import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

/// A synchronized overlay component providing contextual navigation and 
/// environmental configuration controls for the active reading session.
class ReaderBottomBar extends StatelessWidget {
  final bool canGoPrevious;
  final bool canGoNext;
  final Animation<double> controlsOpacity;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSettings;

  const ReaderBottomBar({
    super.key,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.controlsOpacity,
    required this.onPrevious,
    required this.onNext,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: controlsOpacity,
        child: Container(
          decoration: BoxDecoration(
            color: NovonColors.surface,
            border: Border(
              top: BorderSide(
                color: NovonColors.textPrimary.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ControlButton(
                    icon: Icons.skip_previous_rounded,
                    label: 'Previous',
                    onTap: canGoPrevious ? onPrevious : () {},
                  ),
                  _ControlButton(
                    icon: Icons.brightness_6_rounded,
                    label: 'Theme',
                    onTap: onSettings,
                  ),
                  _ControlButton(
                    icon: Icons.text_fields_rounded,
                    label: 'Font',
                    onTap: onSettings,
                  ),
                  _ControlButton(
                    icon: Icons.skip_next_rounded,
                    label: 'Next',
                    onTap: canGoNext ? onNext : () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: NovonColors.textPrimary, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: NovonColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
