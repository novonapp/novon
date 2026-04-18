import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

class ReaderSliderTile extends StatelessWidget {
  final String label;
  final String valueLabel;
  final Widget slider;

  const ReaderSliderTile({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.slider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: NovonColors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                valueLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: NovonColors.primary,
                ),
              ),
            ),
          ],
        ),
        slider,
      ],
    );
  }
}
