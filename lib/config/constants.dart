import 'package:flutter/material.dart';
// Import new design system files
export 'app_colors.dart';
export 'app_typography.dart';
export 'app_button_styles.dart';
export 'app_theme.dart';

class Constants {
  static const String apiBaseUrl = 'http://localhost:8000/v1';
}

class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:8000/v1';
  
  // Colors - keeping backward compatibility, delegate to new AppColors
  static const Color primaryText = Color(0xFF333333);
  static const Color secondaryText = Color(0xFF666666);
  static const Color hintText = Color(0xFF999999);
  static const Color linkText = Color(0xFFDAB360);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color focusedBorderColor = Color(0xFFDAB360);
  static const Color optionBorderColor = Color(0xFFEFC87A);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color warningColor = Color(0xFFFF9800);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFDAB360),
      Color(0xFF906C2A),
      Color(0xFF8C6829),
    ],
    stops: [0.0, 0.8317, 1.0],
  );
  
  static const LinearGradient goldenGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFDAB360),
      Color(0xFF906C2A),
      Color(0xFF8C6829),
    ],
    stops: [0.0, 0.8317, 1.0],
  );
  
  static const LinearGradient optionsGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFE8E8E8)],
  );
}
