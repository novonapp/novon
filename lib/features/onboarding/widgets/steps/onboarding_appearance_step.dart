import 'package:flutter/material.dart';
import '../onboarding_widgets.dart';

class OnboardingAppearanceStep extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String selectedTheme;
  final int selectedAccent;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<int> onAccentChanged;

  const OnboardingAppearanceStep({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.selectedTheme,
    required this.selectedAccent,
    required this.onNext,
    required this.onPrev,
    required this.onThemeChanged,
    required this.onAccentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      title: 'Appearance',
      subtitle: 'Choose your default look. You can change it anytime later.',
      primaryLabel: 'Continue',
      onPrimary: onNext,
      onSecondary: onPrev,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OnboardingThemeOptionCard(
                  title: 'Light',
                  icon: Icons.light_mode_rounded,
                  selected: selectedTheme == 'light',
                  onTap: () => onThemeChanged('light'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OnboardingThemeOptionCard(
                  title: 'Dark',
                  icon: Icons.dark_mode_rounded,
                  selected: selectedTheme == 'dark',
                  onTap: () => onThemeChanged('dark'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OnboardingThemeOptionCard(
                  title: 'System',
                  icon: Icons.settings_suggest_rounded,
                  selected: selectedTheme == 'system',
                  onTap: () => onThemeChanged('system'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Accent color',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                [
                      0xFF6C63FF,
                      0xFF4A90E2,
                      0xFF00A896,
                      0xFFFF6B35,
                      0xFFF9C80E,
                      0xFFDE4D86,
                    ]
                    .map((value) {
                      final isActive = selectedAccent == value;
                      return GestureDetector(
                        onTap: () => onAccentChanged(value),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(value),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(value).withValues(alpha: 0.45),
                                blurRadius: isActive ? 12 : 0,
                                spreadRadius: isActive ? 1 : 0,
                              ),
                            ],
                          ),
                          child: isActive
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    })
                    .toList(growable: false),
          ),
        ],
      ),
    );
  }
}
