import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:novon/core/services/update_service.dart';
import 'package:novon/features/security/providers/lock_provider.dart';
import '../../../core/theme/theme_provider.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import 'package:novon/core/common/constants/router_constants.dart';
import 'package:novon/core/common/constants/app_constants.dart';

/// Primary bootstrap orchestration interface, responsible for application warmup,
/// settings pre-loading, and primary navigation routing upon environment readiness.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const _minSplashDuration = Duration(milliseconds: 850);
  bool _bootstrapped = false;

  /// Orchestrates the critical initial initialization sequence, pre-loading
  /// essential application and reader configurations to ensure UI stability.
  Future<void> _bootstrap() async {
    if (_bootstrapped) return;
    _bootstrapped = true;
    final startedAt = DateTime.now();

    final appBox = Hive.box(HiveBox.app);
    final readerBox = Hive.box(HiveBox.reader);

    // Preload common app/reader settings so first opened screens render stable.
    appBox.get(HiveKeys.appTheme, defaultValue: AppConstants.defaultTheme);
    appBox.get(
      HiveKeys.accentColor,
      defaultValue: AppConstants.defaultAccentColor,
    );
    appBox.get(
      HiveKeys.libraryDisplayMode,
      defaultValue: AppConstants.defaultLibraryDisplayMode,
    );
    appBox.get(
      HiveKeys.libraryGridColumns,
      defaultValue: AppConstants.defaultLibraryGridColumns,
    );
    appBox.get(
      HiveKeys.chapterProgress,
      defaultValue: const <String, dynamic>{},
    );
    appBox.get(
      HiveKeys.novelLastChapter,
      defaultValue: const <String, dynamic>{},
    );
    readerBox.get(
      HiveKeys.readerFontFamily,
      defaultValue: AppConstants.defaultReaderFont,
    );
    readerBox.get(
      HiveKeys.readerFontSize,
      defaultValue: AppConstants.defaultReaderFontSize,
    );
    readerBox.get(
      HiveKeys.readerLineHeight,
      defaultValue: AppConstants.defaultReaderLineHeight,
    );
    readerBox.get(HiveKeys.readerCustomBg);
    readerBox.get(HiveKeys.readerCustomText);

    try {
      // Force theme provider initialization on splash.
      ref.read(themeProvider);
    } catch (_) {
      // Never block startup forever if settings warmup fails.
    }

    final elapsed = DateTime.now().difference(startedAt);
    final remaining = _minSplashDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
    final isLocked = ref.read(isAppLockedProvider);
    if (isLocked) {
      return;
    }

    if (!mounted) return;

    // Check for updates on startup as requested.
    final updateInfo = await ref.read(updateServiceProvider).checkForUpdate();
    if (updateInfo != null && mounted) {
      context.go(RouterConstants.pathAppUpdate, extra: updateInfo);
      return;
    }

    if (!mounted) return;
    context.go(RouterConstants.pathLibrary);
  }

  /// Attempts to transition the navigational state to the primary library surface
  /// while managing potential orchestration failures.
  void _attemptNavigation() async {
    try {
      await Future.delayed(_minSplashDuration);
      if (!mounted) return;
      context.go(RouterConstants.pathLibrary);
    } catch (e) {
      log(
        "failed to navigate to library screen: $e",
        error: e,
        stackTrace: StackTrace.current,
      );
    } finally {
      if (mounted) {
        context.go(RouterConstants.pathLibrary);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(isAppLockedProvider, (previous, next) {
      if (previous == true && next == false) {
        _attemptNavigation();
      }
    });
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConstants.appName.toUpperCase(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your novel universe, offline-first.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
