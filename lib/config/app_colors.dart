import 'package:flutter/material.dart';

/// App-wide color constants following design system
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFFDAB360); // Golden
  static const Color primaryDark = Color(0xFFB8935E);
  static const Color primaryLight = Color(0xFFE5C67C);
  static const Color primaryGold = Color(0xFFDAB360); // Alias for backward compatibility
  static const Color primaryGoldDark = Color(0xFF8C6829);
  static const Color primaryGoldMid = Color(0xFF906C2A);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF8B4513); // Brown
  static const Color secondaryDark = Color(0xFF5D2E0C);
  static const Color secondaryLight = Color(0xFFA0522D);

  // Neutral Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color primaryText = Color(0xFF333333); // Alias for backward compatibility
  static const Color textSecondary = Color(0xFF666666);
  static const Color secondaryText = Color(0xFF666666); // Alias for backward compatibility
  static const Color textTertiary = Color(0xFF999999);
  static const Color hintText = Color(0xFF999999); // Alias for backward compatibility
  static const Color textDisabled = Color(0xFFCCCCCC);
  static const Color linkText = Color(0xFFDAB360); // Alias for backward compatibility
  
  // Background Colors
  static const Color background = Color(0xFFFAF7F2); // Cream/off-white
  static const Color backgroundColor = Color(0xFFFAF7F2); // Alias for backward compatibility
  static const Color backgroundLight = Color(0xFFFFFBF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF); // Alias for backward compatibility
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successColor = Color(0xFF4CAF50); // Alias for backward compatibility
  static const Color error = Color(0xFFF44336);
  static const Color errorColor = Color(0xFFF44336); // Alias for backward compatibility
  static const Color warning = Color(0xFFFF9800);
  static const Color warningColor = Color(0xFFFF9800); // Alias for backward compatibility
  static const Color info = Color(0xFF2196F3);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderColor = Color(0xFFE0E0E0); // Alias for backward compatibility
  static const Color borderDark = Color(0xFFBDBDBD);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color focusedBorderColor = Color(0xFFDAB360); // Alias for backward compatibility
  static const Color optionBorderColor = Color(0xFFEFC87A); // Alias for backward compatibility
  
  // Social Colors
  static const Color googleButtonBorder = Color(0xFFE0E0E0);
  static const Color facebookButtonColor = Color(0xFF1877F2);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDAB360), Color(0xFFB8935E)],
  );
  
  static const LinearGradient goldenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFDAB360), Color(0xFFB8935E)],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFBF5), Color(0xFFFAF7F2)],
  );

  // Opacity variations
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // Material color swatch for ThemeData
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFDAB360,
    <int, Color>{
      50: Color(0xFFFFF9ED),
      100: Color(0xFFFEF0D1),
      200: Color(0xFFFDE6B3),
      300: Color(0xFFFBDC94),
      400: Color(0xFFFAD47D),
      500: Color(0xFFDAB360),
      600: Color(0xFFCEA355),
      700: Color(0xFFC19349),
      800: Color(0xFFB8935E),
      900: Color(0xFFA67B3F),
    },
  );
}
