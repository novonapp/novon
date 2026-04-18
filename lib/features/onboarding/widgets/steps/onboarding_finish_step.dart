import 'package:flutter/material.dart';
import '../onboarding_widgets.dart';
import '../../../../core/common/widgets/branding_logo.dart';
import '../../../../core/theme/novon_colors.dart';

class OnboardingFinishStep extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onFinish;
  final VoidCallback onPrev;

  const OnboardingFinishStep({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onFinish,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      title: 'You are ready to read',
      subtitle:
          'Your environment is configured. Next, install sources and build your library.',
      primaryLabel: 'Go to Home',
      onPrimary: onFinish,
      onSecondary: onPrev,
      content: Column(
        children: [
          OnboardingHeroCard(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const BrandingLogo(size: 82),
                    Positioned(
                      right: -8,
                      bottom: -6,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: NovonColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Setup complete',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const OnboardingChecklistTile(
            icon: Icons.extension_rounded,
            title: 'Browse > Extensions',
            subtitle: 'Install at least one source to start browsing.',
          ),
          const OnboardingChecklistTile(
            icon: Icons.search_rounded,
            title: 'Browse > Search',
            subtitle: 'Discover novels and add your favorites.',
          ),
          const OnboardingChecklistTile(
            icon: Icons.library_books_rounded,
            title: 'Library',
            subtitle: 'Track and organize your reading collection.',
          ),
        ],
      ),
    );
  }
}
