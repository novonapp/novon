import 'package:flutter/material.dart';
import 'pin_button.dart';

/// A standardized numeric input surface designed for secure identifier entry, 
/// supporting haptic feedback and optional biometric integration.
class PinPad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onBiometricPressed;
  final bool showBiometric;

  const PinPad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
    this.onBiometricPressed,
    this.showBiometric = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9']
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((d) => PinButton(
                label: d,
                onPressed: () => onDigitPressed(d),
              )).toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PinButton(
                label: showBiometric ? 'bio' : '',
                icon: showBiometric ? Icons.fingerprint_rounded : null,
                onPressed: showBiometric ? onBiometricPressed : null,
                isTransparent: true,
              ),
              PinButton(
                label: '0',
                onPressed: () => onDigitPressed('0'),
              ),
              PinButton(
                label: 'del',
                icon: Icons.backspace_outlined,
                onPressed: onDeletePressed,
                isTransparent: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
