import 'package:flutter/material.dart';
import 'package:front/core/components/theme.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class AppTheme {
  static AppThemeMode _mode = AppThemeMode.system;

  static void setMode(AppThemeMode mode) {
    _mode = mode;
  }

  static AppThemeMode get mode => _mode;

  static bool get isDark {
    switch (_mode) {
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.light:
        return false;
      case AppThemeMode.system:
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark;
    }
  }

  static AppColorsAccessor get colors => AppColorsAccessor();
}

class AppColorsAccessor {
  // ===== BACKGROUND =====
  Color get bg => AppTheme.isDark ? AppDarkColors.bg : AppLightColors.bg;
  Color get border => AppTheme.isDark ? AppDarkColors.border : AppLightColors.lightBorder;

  // ===== TEXT =====
  Color get text => AppTheme.isDark ? AppDarkColors.text : AppLightColors.lightText;
  Color get gray => AppTheme.isDark ? AppDarkColors.gray : AppLightColors.gray;

  // ===== BRAND =====
  Color get primarySoft => AppTheme.isDark ? AppDarkColors.primarySecond : AppLightColors.primarySecond;

  // ===== STATUS =====
  Color get primary => AppColors.primary;
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get error => AppColors.error;
}