import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'core/theme/novon_colors.dart';
import 'core/router/router.dart';
import 'features/security/widgets/app_lock_gate.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/novon_theme.dart';

/// Root application orchestration layer, responsible for reactive theme resolution, 
/// global security interception via [AppLockGate], and navigational routing.
class NovonApp extends ConsumerWidget {
  const NovonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    // Appraises the optimal system UI styling based on current application 
    // state and platform-native brightness preferences.
    final isDark = themeState.mode == ThemeMode.dark || themeState.isAmoled || 
        (themeState.mode == ThemeMode.system && PlatformDispatcher.instance.platformBrightness == Brightness.dark);

    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDark 
          ? (themeState.isAmoled ? NovonColors.amoledSurface : NovonColors.surface) 
          : NovonColors.lightSurface,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: MaterialApp.router(
        title: 'Novon',
        debugShowCheckedModeBanner: false,
        theme: NovonTheme.lightTheme(themeState.primaryColor),
        darkTheme: themeState.isAmoled
            ? NovonTheme.amoledTheme(themeState.primaryColor)
            : NovonTheme.darkTheme(themeState.primaryColor),
        themeMode: themeState.mode,
        routerConfig: novonRouter,
        builder: (context, child) {
          if (child == null) return const SizedBox.shrink();
          return AppLockGate(child: child);
        },
      ),
    );
  }
}
