import 'package:flutter/material.dart';

class Constants {
  static const String apiBaseUrl = 'http://localhost:8000/v1';
}

class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:8000/v1';
  
  // Colors - delegate to AppColors
  static Color get primaryText => AppColors.primaryText;
  static Color get secondaryText => AppColors.secondaryText;
  static Color get hintText => AppColors.hintText;
  static Color get linkText => AppColors.linkText;
  static Color get borderColor => AppColors.borderColor;
  static Color get focusedBorderColor => AppColors.focusedBorderColor;
  static Color get optionBorderColor => AppColors.optionBorderColor;
  static Color get successColor => AppColors.successColor;
  static Color get errorColor => AppColors.errorColor;
  static Color get warningColor => AppColors.warningColor;
  
  // Gradients - delegate to AppColors
  static LinearGradient get primaryGradient => AppColors.primaryGradient;
  static LinearGradient get goldenGradient => AppColors.goldenGradient;
  static LinearGradient get optionsGradient => AppColors.optionsGradient;
}

class AppColors {
  // Primary golden/brown theme colors from design
  static const Color primaryGold = Color(0xFFDAB360); // Updated to match gradient start
  static const Color primaryGoldDark = Color(0xFF8C6829); // Updated to match gradient end
  static const Color primaryGoldMid = Color(0xFF906C2A); // Gradient middle color
  static const Color primaryGoldLight = Color(0xFFDAA520); // Lighter shade for highlights
  
  // Gradient colors for linear gradient: #DAB360 -> #906C2A -> #8C6829
  static const List<Color> primaryGradientColors = [
    Color(0xFFDAB360), // 0%
    Color(0xFF906C2A), // 83.17%
    Color(0xFF8C6829), // 100%
  ];
  
  static const List<double> primaryGradientStops = [0.0, 0.8317, 1.0];
  
  // Text background color
  static const Color textBackgroundColor = Color(0xFFC2B068);
  
  // Background colors
  static const Color backgroundColor = Color(0xFFFAF9F6); // Cream/off-white background
  static const Color cardBackground = Colors.white;
  
  // Text colors
  static const Color primaryText = Color(0xFF300700); // Dark brown text for loan screens
  static const Color secondaryText = Color(0xFF666666); // Gray text
  static const Color hintText = Color(0xFF999999); // Light gray for hints
  static const Color linkText = Color(0xFFDAB360); // Updated to match gradient start
  
  // Border and divider colors
  static const Color borderColor = Color(0xFFE0E0E0); // Light gray borders
  static const Color focusedBorderColor = Color(0xFFDAB360); // Updated to match gradient start
  static const Color optionBorderColor = Color(0xFFEFC87A); // Golden border for options
  
  // Status colors
  static const Color successColor = Color(0xFF4CAF50); // Green for success
  static const Color errorColor = Color(0xFFE53E3E); // Red for errors
  static const Color warningColor = Color(0xFFFF9800); // Orange for warnings
  
  // Social button colors
  static const Color googleButtonBorder = Color(0xFFE0E0E0);
  static const Color facebookButtonColor = Color(0xFF1877F2);
  
  // Helper methods for gradients
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: primaryGradientColors,
    stops: primaryGradientStops,
  );
  
  // Golden gradient for loan screens (BG 1)
  static LinearGradient get goldenGradient => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFDAB360), // #DAB360 at 0%
      Color(0xFF906C2A), // #906C2A at 83.17%  
      Color(0xFF8C6829), // #8C6829 at 100%
    ],
    stops: [0.0, 0.8317, 1.0],
  );
  
  // Other options gradient  
  static LinearGradient get optionsGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFE8E8E8)],
    stops: [0.0, 1.0],
  );
}
