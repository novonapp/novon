import 'package:flutter/material.dart';
import '../onboarding_widgets.dart';

class OnboardingPermissionsStep extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool storageGranted;
  final bool notificationsGranted;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onRequestStorage;
  final VoidCallback onRequestNotifications;

  const OnboardingPermissionsStep({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.storageGranted,
    required this.notificationsGranted,
    required this.onNext,
    required this.onPrev,
    required this.onRequestStorage,
    required this.onRequestNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      title: 'Permissions',
      subtitle:
          'Grant required access now for smooth downloads and notifications.',
      primaryLabel: 'Continue',
      onPrimary: (storageGranted && notificationsGranted) ? onNext : null,
      onSecondary: onPrev,
      content: Column(
        children: [
          OnboardingPermissionTile(
            icon: Icons.folder_copy_rounded,
            title: 'Storage',
            subtitle:
                'Required to save your database, settings, and downloads.',
            granted: storageGranted,
            buttonLabel: storageGranted ? 'Granted' : 'Grant',
            onPressed: storageGranted ? null : onRequestStorage,
          ),
          const SizedBox(height: 12),
          OnboardingPermissionTile(
            icon: Icons.notifications_active_rounded,
            title: 'Notifications',
            subtitle: 'Required alerts for download progress and completion.',
            granted: notificationsGranted,
            buttonLabel: notificationsGranted ? 'Granted' : 'Grant',
            onPressed: notificationsGranted
                ? null
                : onRequestNotifications,
          ),
        ],
      ),
    );
  }
}
