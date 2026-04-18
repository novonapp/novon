import 'package:flutter/material.dart';
import '../onboarding_widgets.dart';
import '../../../../core/theme/novon_colors.dart';

class OnboardingStorageStep extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String? selectedFolderPath;
  final bool storageValid;
  final String storageMessage;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onPickFolder;

  const OnboardingStorageStep({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.selectedFolderPath,
    required this.storageValid,
    required this.storageMessage,
    required this.onNext,
    required this.onPrev,
    required this.onPickFolder,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      title: 'Select your Novon folder',
      subtitle:
          'This folder stores your library database, source settings, backups, and downloaded chapters.',
      primaryLabel: 'Continue',
      onPrimary: storageValid ? onNext : null,
      onSecondary: onPrev,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingHeroCard(
            child: Column(
              children: [
                Icon(
                  Icons.folder_special_rounded,
                  size: 40,
                  color: storageValid
                      ? NovonColors.success
                      : NovonColors.textSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  selectedFolderPath ?? 'No folder selected yet',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: storageValid
                        ? NovonColors.success
                        : NovonColors.textPrimary,
                    height: 1.35,
                  ),
                ),
                if (storageMessage.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    storageMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: storageValid
                          ? NovonColors.success
                          : NovonColors.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: onPickFolder,
                  icon: const Icon(Icons.folder_open_rounded),
                  label: const Text('Choose Folder'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const OnboardingChecklistTile(
            icon: Icons.sync_alt_rounded,
            title: 'Instant sync in this session',
            subtitle:
                'If this folder already has Novon data, it loads immediately.',
          ),
          const OnboardingChecklistTile(
            icon: Icons.device_hub_rounded,
            title: 'Easy migration',
            subtitle: 'Copy this folder to move your setup across devices.',
          ),
        ],
      ),
    );
  }
}
