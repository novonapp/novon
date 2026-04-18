import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:novon/features/security/providers/lock_provider.dart';
import './pin_widgets.dart';
import '../../../core/theme/novon_colors.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import '../../../core/common/widgets/branding_logo.dart';

/// A specialized security interceptor that wraps the application interface, 
/// conditionally enforcing authentication based on lifecycle transitions 
/// and persistent security configurations.
class AppLockGate extends ConsumerStatefulWidget {
  final Widget child;

  const AppLockGate({super.key, required this.child});

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();

  bool _locked = false;
  bool _authInProgress = false;
  DateTime? _lastPausedAt;

  String _currentPinEntry = '';
  bool _isPinError = false;
  String? _lockType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _evaluateLock(initial: true),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Synchronizes security state with application lifecycle transitions.
  /// 
  /// Captures temporal anchors upon backgrounding to facilitate precise 
  /// enforcement of the automatic relock timeout upon resumption.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _lastPausedAt = DateTime.now();
      return;
    }
    if (state == AppLifecycleState.resumed) {
      _evaluateLock(initial: false);
    }
  }

  /// Orchestrates the appraisal of current security requirements, comparing 
  /// background durations against configured timeout thresholds to 
  /// determine if an authentication obstructer is necessitated.
  Future<void> _evaluateLock({required bool initial}) async {
    if (!mounted) return;

    final box = Hive.box(HiveBox.app);
    final enabled =
        box.get(HiveKeys.appLockEnabled, defaultValue: false) == true;
    if (!enabled) {
      if (_locked) {
        setState(() => _locked = false);
        ref.read(isAppLockedProvider.notifier).state = false;
      }
      return;
    }

    final timeoutSeconds =
        (box.get(HiveKeys.appLockTimeout, defaultValue: 15) as num?)
            ?.toInt() ??
        15;
    final pauseElapsed = _lastPausedAt == null
        ? Duration.zero
        : DateTime.now().difference(_lastPausedAt!);
    final shouldRequireAuth =
        initial || pauseElapsed.inSeconds >= timeoutSeconds;
    if (!shouldRequireAuth) return;

    if (!_locked) {
      setState(() {
        _locked = true;
        ref.read(isAppLockedProvider.notifier).state = true;
        _currentPinEntry = '';
        _isPinError = false;
        _lockType = box.get(
          HiveKeys.appLockType,
          defaultValue: 'biometric',
        );
      });
    }

    if (_lockType == 'biometric') {
      await _tryUnlockBiometric();
    }
  }

  Future<void> _tryUnlockBiometric() async {
    if (_authInProgress || !mounted) return;
    _authInProgress = true;
    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      if (!isSupported && !canCheck) return;

      final didAuth = await _auth.authenticate(
        localizedReason: 'Authenticate to unlock Novon',
        biometricOnly: false,
        sensitiveTransaction: true,
      );
      if (!mounted) return;
      if (didAuth) {
        setState(() => _locked = false);
        ref.read(isAppLockedProvider.notifier).state = false;
      }
    } catch (_) {
    } finally {
      _authInProgress = false;
    }
  }

  Future<void> _handlePinDigit(String digit) async {
    if (_currentPinEntry.length < 4) {
      setState(() {
        _currentPinEntry += digit;
        _isPinError = false;
      });

      if (_currentPinEntry.length == 4) {
        final savedPin = await _storage.read(key: 'app_lock_custom_pin');
        if (_currentPinEntry == savedPin) {
          setState(() {
            _locked = false;
            ref.read(isAppLockedProvider.notifier).state = false;
            _currentPinEntry = '';
          });
        } else {
          HapticFeedback.heavyImpact();
          setState(() {
            _isPinError = true;
            _currentPinEntry = '';
          });
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) setState(() => _isPinError = false);
          });
        }
      }
    }
  }

  void _handlePinDelete() {
    if (_currentPinEntry.isNotEmpty) {
      setState(() {
        _currentPinEntry = _currentPinEntry.substring(
          0,
          _currentPinEntry.length - 1,
        );
        _isPinError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_locked) return widget.child;
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: ColoredBox(
              color: NovonColors.background.withValues(alpha: 0.98),
              child: SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: NovonColors.primary.withValues(alpha: 0.1),
                      ),
                      child: const Center(
                        child: BrandingLogo(size: 40),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Novon is Locked',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lockType == 'pin'
                          ? 'Enter your custom PIN to continue'
                          : 'Use biometrics to unlock',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: NovonColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    if (_lockType == 'pin') ...[
                      PinIndicator(
                        length: 4,
                        currentLength: _currentPinEntry.length,
                        isError: _isPinError,
                      ),
                      const Spacer(),
                      PinPad(
                        onDigitPressed: _handlePinDigit,
                        onDeletePressed: _handlePinDelete,
                        showBiometric: true,
                        onBiometricPressed: _tryUnlockBiometric,
                      ),
                    ] else ...[
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _tryUnlockBiometric,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.fingerprint_rounded),
                        label: const Text(
                          'Unlock with Biometrics',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const Spacer(),
                    ],
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
