import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Reusable button styles following design system
class AppButtonStyles {
  AppButtonStyles._(); // Private constructor to prevent instantiation

  // Primary Button Style
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    textStyle: AppTypography.button,
    minimumSize: const Size(double.infinity, 50),
  );

  // Primary Button with Gradient (for Container wrapper)
  static BoxDecoration primaryGradient = BoxDecoration(
    gradient: AppColors.goldenGradient,
    borderRadius: BorderRadius.circular(12),
  );

  // Primary Button Style (compact)
  static ButtonStyle primaryCompact = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
    textStyle: AppTypography.buttonSmall,
  );

  // Compact Button with Gradient
  static BoxDecoration primaryCompactGradient = BoxDecoration(
    gradient: AppColors.goldenGradient,
    borderRadius: BorderRadius.circular(8),
  );

  // Secondary Button Style
  static ButtonStyle secondary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryDark,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    textStyle: AppTypography.button,
    minimumSize: const Size(double.infinity, 50),
  );

  // Outlined Button Style
  static ButtonStyle outlined = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    side: const BorderSide(color: AppColors.primary, width: 2),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: AppTypography.button,
    minimumSize: const Size(double.infinity, 50),
  );

  // Text Button Style
  static ButtonStyle text = TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: AppTypography.button,
  );

  // Error/Danger Button Style
  static ButtonStyle danger = ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    textStyle: AppTypography.button,
    minimumSize: const Size(double.infinity, 50),
  );

  // Success Button Style
  static ButtonStyle success = ElevatedButton.styleFrom(
    backgroundColor: AppColors.success,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    textStyle: AppTypography.button,
    minimumSize: const Size(double.infinity, 50),
  );

  // White Button Style (for dark backgrounds)
  static ButtonStyle white = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    textStyle: AppTypography.button,
    minimumSize: const Size(double.infinity, 50),
  );

  // Small Button Style
  static ButtonStyle small = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
    textStyle: AppTypography.buttonSmall,
    minimumSize: const Size(80, 36),
  );

  // Icon Button Style
  static ButtonStyle icon = IconButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Disabled Button Style
  static ButtonStyle disabled = ElevatedButton.styleFrom(
    backgroundColor: AppColors.textDisabled,
    foregroundColor: AppColors.textTertiary,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    textStyle: AppTypography.button,
    minimumSize: const Size(double.infinity, 50),
  );

  // Custom button style with specific color
  static ButtonStyle custom({
    required Color backgroundColor,
    required Color foregroundColor,
    double borderRadius = 12,
    EdgeInsets? padding,
    TextStyle? textStyle,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 0,
      textStyle: textStyle ?? AppTypography.button,
      minimumSize: const Size(double.infinity, 50),
    );
  }
}
