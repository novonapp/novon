import 'package:flutter/material.dart';
import '../onboarding_widgets.dart';

class OnboardingTourStep extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const OnboardingTourStep({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      title: 'What you can do',
      subtitle: 'A quick overview before we configure your environment.',
      primaryLabel: 'Continue',
      onPrimary: onNext,
      onSecondary: onPrev,
      content: const Column(
        children: [
          OnboardingFeatureBlock(
            icon: Icons.extension_rounded,
            title: 'Install source extensions',
            description:
                'Add only the sources you need and keep your catalog focused.',
          ),
          OnboardingFeatureBlock(
            icon: Icons.search_rounded,
            title: 'Discover and save',
            description:
                'Search, bookmark, and build a clean personal library.',
          ),
          OnboardingFeatureBlock(
            icon: Icons.download_for_offline_rounded,
            title: 'Read offline',
            description:
                'Download chapters and continue reading without internet.',
          ),
          OnboardingFeatureBlock(
            icon: Icons.backup_rounded,
            title: 'Own your data',
            description:
                'No account required. Your folder is your full backup.',
          ),
        ],
      ),
    );
  }
}
