import 'package:flutter/material.dart';
import '../onboarding_widgets.dart';
import '../../../../core/theme/novon_colors.dart';

class OnboardingLanguageStep extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Set<String> selectedLanguages;
  final List<LanguageOption> languages;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final void Function(String, bool) onLanguageSelected;

  const OnboardingLanguageStep({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.selectedLanguages,
    required this.languages,
    required this.onNext,
    required this.onPrev,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      title: 'Reading language',
      subtitle:
          'Set your preferred languages to prioritize relevant source extensions.',
      primaryLabel: 'Continue',
      onPrimary: selectedLanguages.isNotEmpty ? onNext : null,
      onSecondary: onPrev,
      content: Wrap(
        spacing: 10,
        runSpacing: 12,
        children: languages
            .map((language) {
              final selected = selectedLanguages.contains(language.code);
              return FilterChip(
                label: Text('${language.emoji} ${language.name}'),
                selected: selected,
                onSelected: (isSelected) => onLanguageSelected(language.code, isSelected),
                selectedColor: NovonColors.primary.withValues(alpha: 0.16),
                checkmarkColor: NovonColors.primary,
                side: BorderSide(
                  color: NovonColors.border.withValues(alpha: 0.36),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
