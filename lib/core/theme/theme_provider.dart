import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './novon_colors.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

class AppThemeState {
  final ThemeMode mode;
  final bool isAmoled;
  final Color primaryColor;

  AppThemeState({
    required this.mode,
    required this.isAmoled,
    required this.primaryColor,
  });
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeState>((
  ref,
) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppThemeState> {
  ThemeNotifier()
    : super(
        AppThemeState(
          mode: ThemeMode.dark,
          isAmoled: false,
          primaryColor: const Color(0xFF6C63FF),
        ),
      ) {
    _loadTheme();
  }

  void _loadTheme() {
    final box = Hive.box(HiveBox.app);
    final themeString = box.get(HiveKeys.appTheme, defaultValue: 'dark');
    final accentValue =
        box.get(HiveKeys.accentColor, defaultValue: 0xFF6C63FF) as int;

    // Inject dynamic colors into NovonColors globally
    final bgColor = box.get(HiveKeys.customBgColor);
    final surfaceColor = box.get(HiveKeys.customSurfaceColor);

    if (bgColor != null) {
      final c = Color(bgColor);
      NovonColors.background = c;
      NovonColors.lightBackground = c;
      NovonColors.amoledBackground = c;
    }
    if (surfaceColor != null) {
      final c = Color(surfaceColor);
      NovonColors.surface = c;
      NovonColors.lightSurface = c;
      NovonColors.amoledSurface = c;
    }

    NovonColors.primary = Color(accentValue);

    _applyTheme(themeString, Color(accentValue));
  }

  void updateTheme(String themeString) {
    final box = Hive.box(HiveBox.app);
    box.put(HiveKeys.appTheme, themeString);
    final accentValue =
        box.get(HiveKeys.accentColor, defaultValue: 0xFF6C63FF) as int;
    _applyTheme(themeString, Color(accentValue));
  }

  void updateAccentColor(Color color) {
    final box = Hive.box(HiveBox.app);
    box.put(HiveKeys.accentColor, color.toARGB32());
    NovonColors.primary = color;
    final themeString = box.get(HiveKeys.appTheme, defaultValue: 'dark');
    _applyTheme(themeString, color);
  }

  void updateBackgroundColor(Color color) {
    final box = Hive.box(HiveBox.app);
    box.put(HiveKeys.customBgColor, color.toARGB32());
    NovonColors.background = color;
    NovonColors.lightBackground = color;
    NovonColors.amoledBackground = color;
    final themeString = box.get(HiveKeys.appTheme, defaultValue: 'dark');
    final accentValue =
        box.get(HiveKeys.accentColor, defaultValue: 0xFF6C63FF) as int;
    _applyTheme(themeString, Color(accentValue));
  }

  void updateSurfaceColor(Color color) {
    final box = Hive.box(HiveBox.app);
    box.put(HiveKeys.customSurfaceColor, color.toARGB32());
    NovonColors.surface = color;
    NovonColors.lightSurface = color;
    NovonColors.amoledSurface = color;
    final themeString = box.get(HiveKeys.appTheme, defaultValue: 'dark');
    final accentValue =
        box.get(HiveKeys.accentColor, defaultValue: 0xFF6C63FF) as int;
    _applyTheme(themeString, Color(accentValue));
  }

  void resetColors() {
    final box = Hive.box(HiveBox.app);
    box.delete(HiveKeys.accentColor);
    box.delete(HiveKeys.customBgColor);
    box.delete(HiveKeys.customSurfaceColor);

    NovonColors.primary = const Color(0xFF6C63FF);
    NovonColors.background = const Color(0xFF0D0D0F);
    NovonColors.surface = const Color(0xFF16161A);
    NovonColors.lightBackground = const Color(0xFFF8F8FC);
    NovonColors.lightSurface = const Color(0xFFFFFFFF);
    NovonColors.amoledBackground = const Color(0xFF000000);
    NovonColors.amoledSurface = const Color(0xFF0A0A0A);

    final themeString = box.get(HiveKeys.appTheme, defaultValue: 'dark');
    _applyTheme(themeString, const Color(0xFF6C63FF));
  }

  void _applyTheme(String themeString, Color primaryColor) {
    ThemeMode md;
    bool isAmoled = false;

    switch (themeString) {
      case 'light':
        md = ThemeMode.light;
        break;
      case 'amoled':
        md = ThemeMode.dark;
        isAmoled = true;
        break;
      case 'system':
        md = ThemeMode.system;
        break;
      case 'dark':
      default:
        md = ThemeMode.dark;
        break;
    }

    state = AppThemeState(
      mode: md,
      isAmoled: isAmoled,
      primaryColor: primaryColor,
    );
  }
}
