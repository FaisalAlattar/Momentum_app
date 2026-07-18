import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  // Singleton pattern
  static final AppColors _instance = AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  AppColors._internal();

  bool get _isDark => Get.isDarkMode;

  // Background
  Color get background =>
      _isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF);

  // Surface (cards, dialogs, bottom sheets, bottom nav bar)
  Color get surface =>
      _isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);

  // Text Colors
  Color get textPrimary =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF121212);
  Color get textSecondary =>
      _isDark ? const Color(0xFFAAAAAA) : const Color(0xFF666666);
  Color get textMuted =>
      _isDark ? const Color(0xFF757575) : const Color(0xFF9E9E9E);

  // Borders & Dividers
  Color get border =>
      _isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0);

  // Interactive Elements Background (e.g. unselected icons, text field background)
  Color get surfaceHighlight => _isDark
      ? const Color(0xFF2C2C2C)
      : const Color(0xFF121212).withValues(alpha: 0.03);

  // Pure colors (always remain the same)
  final Color pureWhite = const Color(0xFFFFFFFF);
  final Color pureBlack = const Color(0xFF000000);

  // Brand Colors
  final Color lightBlue = const Color(0xFF00B4DB);

  // We keep `black` and `white` for backwards compatibility until all files are fully migrated.
  // However, it is strongly recommended to use textPrimary, surface, and pureWhite instead.
  Color get black => textPrimary;
  Color get white => pureWhite;

  // Status Colors
  final Color green = const Color(0xFF10B981); // Premium modern green

  // Gradient Colors
  LinearGradient get blueBlackGradient => LinearGradient(
    colors: [
      lightBlue,
      _isDark ? const Color(0xFF005668) : const Color(0xFF121212),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
