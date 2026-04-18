import 'package:flutter/material.dart';
import '../onboarding_widgets.dart';
import '../../../../core/common/widgets/branding_logo.dart';
import '../../../../core/theme/novon_colors.dart';

class OnboardingWelcomeStep extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;

  const OnboardingWelcomeStep({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      title: 'Welcome to Novon',
      subtitle:
          'Private reading, portable storage, and a focused setup you can finish in under a minute.',
      primaryLabel: 'Start Setup',
      onPrimary: onNext,
      content: Column(
        children: [
          OnboardingHeroCard(
            child: Column(
              children: [
                const BrandingLogo(size: 84),
                const SizedBox(height: 14),
                Text(
                  'Novon',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Built for readers who want control over their own data.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NovonColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const OnboardingChecklistTile(
            icon: Icons.lock_rounded,
            title: 'Private by default',
            subtitle: 'Reading history, sources, and settings stay local.',
          ),
          const OnboardingChecklistTile(
            icon: Icons.folder_zip_rounded,
            title: 'One portable folder',
            subtitle: 'Back up or move everything in one place.',
          ),
          const OnboardingChecklistTile(
            icon: Icons.speed_rounded,
            title: 'Fast setup flow',
            subtitle: 'Only essential decisions, no extra friction.',
          ),
        ],
      ),
    );
  }
}
