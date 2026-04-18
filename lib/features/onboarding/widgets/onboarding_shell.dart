import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

/// Shell layout for each onboarding step, progress bar, title, content, nav buttons.
class OnboardingShell extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;
  final String subtitle;
  final Widget content;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  const OnboardingShell({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.primaryLabel,
    required this.onPrimary,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = currentStep / totalSteps;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Step $currentStep of $totalSteps',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: NovonColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 8,
                    backgroundColor: NovonColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      NovonColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NovonColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: RepaintBoundary(
                    child: SingleChildScrollView(child: content),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onSecondary,
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: onPrimary,
                        style: FilledButton.styleFrom(
                          backgroundColor: NovonColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(primaryLabel),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
