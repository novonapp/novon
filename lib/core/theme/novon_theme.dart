import 'package:flutter/material.dart';
import 'novon_colors.dart';
import 'novon_typography.dart';

class NovonTheme {
  NovonTheme._();

  static ThemeData darkTheme(Color primary) {
    final textTheme = NovonTypography.textTheme.apply(
      bodyColor: NovonColors.textPrimary,
      displayColor: NovonColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NovonColors.background,
      textTheme: textTheme,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: NovonColors.textOnPrimary,
        secondary: NovonColors.accent,
        onSecondary: Color(0xFF1A1A1A),
        surface: NovonColors.surface,
        onSurface: NovonColors.textPrimary,
        error: NovonColors.error,
        onError: NovonColors.textOnPrimary,
        outline: NovonColors.border,
        surfaceContainerHighest: NovonColors.surfaceVariant,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: NovonColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: NovonColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: NovonColors.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NovonColors.surface,
        selectedItemColor: primary,
        unselectedItemColor: NovonColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 13),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: NovonColors.surface,
        indicatorColor: primary.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 78,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: NovonColors.textTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary, size: 24);
          }
          return IconThemeData(color: NovonColors.textTertiary, size: 24);
        }),
      ),
      cardTheme: CardThemeData(
        color: NovonColors.surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: NovonColors.surfaceVariant,
        selectedColor: primary.withValues(alpha: 0.2),
        labelStyle: textTheme.labelMedium!,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(
        color: NovonColors.divider,
        thickness: 0.5,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NovonColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: NovonColors.textTertiary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      iconTheme: IconThemeData(color: NovonColors.textSecondary, size: 22),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: NovonColors.textOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: NovonColors.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: NovonColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: NovonColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: NovonColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: NovonColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData lightTheme(Color primary) {
    final textTheme = NovonTypography.textTheme.apply(
      bodyColor: NovonColors.textTertiary,
      displayColor: NovonColors.textTertiary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: NovonColors.lightBackground,
      textTheme: textTheme,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: NovonColors.textOnPrimary,
        secondary: NovonColors.accent,
        onSecondary: Color(0xFF1A1A1A),
        surface: NovonColors.lightSurface,
        onSurface: NovonColors.textTertiary,
        error: NovonColors.error,
        onError: NovonColors.textOnPrimary,
        outline: NovonColors.lightSurfaceVariant,
        surfaceContainerHighest: NovonColors.lightSurfaceVariant,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: NovonColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: NovonColors.textTertiary,
        ),
        iconTheme: IconThemeData(color: NovonColors.textTertiary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NovonColors.lightSurface,
        selectedItemColor: primary,
        unselectedItemColor: NovonColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 13),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: NovonColors.lightSurface,
        indicatorColor: primary.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 78,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: NovonColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary, size: 24);
          }
          return IconThemeData(color: NovonColors.textSecondary, size: 24);
        }),
      ),
      cardTheme: CardThemeData(
        color: NovonColors.lightSurfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: NovonColors.lightSurfaceVariant,
        selectedColor: primary.withValues(alpha: 0.2),
        labelStyle: textTheme.labelMedium!,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(
        color: NovonColors.lightSurfaceVariant,
        thickness: 0.5,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NovonColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: NovonColors.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      iconTheme: IconThemeData(color: NovonColors.textSecondary, size: 22),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: NovonColors.textOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: NovonColors.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: NovonColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: NovonColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: NovonColors.lightSurfaceVariant,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: NovonColors.lightSurfaceVariant,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData amoledTheme(Color primary) {
    final textTheme = NovonTypography.textTheme.apply(
      bodyColor: NovonColors.textPrimary,
      displayColor: NovonColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NovonColors.amoledBackground,
      textTheme: textTheme,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: NovonColors.textOnPrimary,
        secondary: NovonColors.accent,
        onSecondary: Color(0xFF1A1A1A),
        surface: NovonColors.amoledSurface,
        onSurface: NovonColors.textPrimary,
        error: NovonColors.error,
        onError: NovonColors.textOnPrimary,
        outline: NovonColors.border,
        surfaceContainerHighest: NovonColors.surfaceVariant,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: NovonColors.amoledSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: NovonColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: NovonColors.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NovonColors.amoledSurface,
        selectedItemColor: primary,
        unselectedItemColor: NovonColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 13),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: NovonColors.amoledSurface,
        indicatorColor: primary.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 78,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: NovonColors.textTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary, size: 24);
          }
          return IconThemeData(color: NovonColors.textTertiary, size: 24);
        }),
      ),
      cardTheme: CardThemeData(
        color: NovonColors.surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: NovonColors.surfaceVariant,
        selectedColor: primary.withValues(alpha: 0.2),
        labelStyle: textTheme.labelMedium!,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(
        color: NovonColors.divider,
        thickness: 0.5,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NovonColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: NovonColors.textTertiary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      iconTheme: IconThemeData(color: NovonColors.textSecondary, size: 22),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: NovonColors.textOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: NovonColors.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: NovonColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: NovonColors.amoledSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: NovonColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: NovonColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
