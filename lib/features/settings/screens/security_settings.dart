import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'settings_template.dart';
import '../../../core/theme/novon_colors.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import 'package:novon/core/common/constants/router_constants.dart';

/// Administration panel for application-level security and privacy configurations,
/// facilitating the management of authentication gates and data protection layers.
class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreenTemplate(
      title: 'Security & Privacy',
      boxName: HiveBox.app,
      buildSettings: (box, update) {
        return [
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline_rounded),
            title: const Text('App Lock'),
            subtitle: const Text('Require biometric or PIN to open Novon'),
            value: box.get(HiveKeys.appLockEnabled, defaultValue: false),
            onChanged: (val) async {
              if (!val) {
                update(HiveKeys.appLockEnabled, false);
                return;
              }

              final result = await _showLockTypeSelection(context);
              if (result == null || !context.mounted) return;

              if (result == 'biometric') {
                final auth = LocalAuthentication();
                final isSupported = await auth.isDeviceSupported();
                final canCheckBiometrics = await auth.canCheckBiometrics;

                if (!context.mounted) return;
                if (!isSupported && !canCheckBiometrics) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No supported biometric found on this device.',
                      ),
                    ),
                  );
                  return;
                }

                final didAuth = await auth.authenticate(
                  localizedReason: 'Authenticate to enable app lock',
                  biometricOnly: false,
                  persistAcrossBackgrounding: true,
                );

                if (!context.mounted) return;
                if (!didAuth) return;

                update(HiveKeys.appLockType, 'biometric');
                update(HiveKeys.appLockEnabled, true);
              } else if (result == 'pin') {
                final pinSet = await context.push<bool>(
                  RouterConstants.pinSetup(),
                );

                if (pinSet == true) {
                  update(HiveKeys.appLockType, 'pin');
                  update(HiveKeys.appLockEnabled, true);
                }
              }

              if (box.get(HiveKeys.appLockEnabled) == true &&
                  !box.containsKey(HiveKeys.appLockTimeout)) {
                update(HiveKeys.appLockTimeout, 15);
              }
            },
          ),
          if (box.get(HiveKeys.appLockEnabled, defaultValue: false)) ...[
            ListTile(
              leading: const Icon(Icons.security_rounded),
              title: const Text('Lock Method'),
              subtitle: Text(
                box.get(HiveKeys.appLockType) == 'pin'
                    ? 'Custom PIN'
                    : 'Biometrics / System Lock',
              ),
              onTap: () async {
                final result = await _showLockTypeSelection(context);
                if (result == null) return;
                if (result == 'pin') {
                  if (!context.mounted) return;
                  final pinSet = await context.push<bool>(
                    RouterConstants.pinSetup(isChangeMode: true),
                  );
                  if (pinSet == true) update(HiveKeys.appLockType, 'pin');
                } else {
                  update(HiveKeys.appLockType, 'biometric');
                }
              },
            ),
            if (box.get(HiveKeys.appLockType) == 'pin')
              ListTile(
                leading: const Icon(Icons.password_rounded),
                title: const Text('Change PIN'),
                onTap: () =>
                    context.push(RouterConstants.pinSetup(isChangeMode: true)),
              ),
          ],
          SwitchListTile(
            secondary: const Icon(Icons.blur_on_rounded),
            title: const Text('Blur Preview in Recents'),
            subtitle: const Text('Hides app content in the task switcher'),
            value: box.get(HiveKeys.blurRecents, defaultValue: false),
            onChanged: (val) => update(HiveKeys.blurRecents, val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.visibility_off_outlined),
            title: const Text('Incognito Mode'),
            subtitle: const Text('Pause reading history while active'),
            value: box.get(HiveKeys.incognitoMode, defaultValue: false),
            onChanged: (val) => update(HiveKeys.incognitoMode, val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.screenshot_monitor_rounded),
            title: const Text('Allow Screenshots in Reader'),
            value: box.get(HiveKeys.allowScreenshots, defaultValue: true),
            onChanged: (val) => update(HiveKeys.allowScreenshots, val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.verified_user_outlined),
            title: const Text('Extension Signature Verification'),
            subtitle: const Text(
              'Disable only for testing unsigned extensions',
            ),
            value: box.get(
              HiveKeys.extensionVerifySignatures,
              defaultValue: true,
            ),
            onChanged: (val) => update(HiveKeys.extensionVerifySignatures, val),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.app_settings_alt_rounded),
            title: const Text('App Permissions'),
            subtitle: const Text('Manage storage and notification permissions'),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            onTap: () async {
              await openAppSettings();
            },
          ),
        ];
      },
    );
  }

  Future<String?> _showLockTypeSelection(BuildContext context) async {
    return showModalBottomSheet<String>(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: NovonColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: NovonColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: NovonColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Choose Lock Method',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Select how you want to secure Novon.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: NovonColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            _LockTypeTile(
              icon: Icons.fingerprint_rounded,
              title: 'Biometrics',
              subtitle: 'Use your fingerprint or face to unlock',
              onTap: () => context.pop('biometric'),
            ),
            const SizedBox(height: 12),
            _LockTypeTile(
              icon: Icons.password_rounded,
              title: 'Custom PIN',
              subtitle: 'Set a private 4-digit code for the app',
              onTap: () => context.pop('pin'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockTypeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LockTypeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: NovonColors.border.withValues(alpha: 0.3)),
          color: NovonColors.surfaceVariant.withValues(alpha: 0.3),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NovonColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: NovonColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: NovonColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: NovonColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
