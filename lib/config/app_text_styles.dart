import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTextStyles {
  // Fallback text styles in case Google Fonts fail to load
  static const TextStyle _fallbackManrope = TextStyle(
    fontFamily: 'system',
  );
  
  static const TextStyle _fallbackPoppins = TextStyle(
    fontFamily: 'system',
  );

  // Safe Google Fonts getters with fallback
  static TextStyle manrope({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    try {
      return GoogleFonts.manrope(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
    } catch (e) {
      // If Google Fonts fails, use system font
      return _fallbackManrope.copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
    }
  }

  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    try {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
    } catch (e) {
      // If Google Fonts fails, use system font
      return _fallbackPoppins.copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
    }
  }

  // Predefined text styles matching the design - All using Poppins
  static TextStyle get appTitle => poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static TextStyle get pageSubtitle => poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );

  // Updated subtitle with text background for highlighted parts
  static TextStyle get pageSubtitleHighlight => poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryGold, // Using gradient start color
  );

  static TextStyle get tabText => poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static TextStyle get tabTextActive => poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get buttonText => poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get fieldLabel => poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static TextStyle get fieldHint => poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.hintText,
  );

  static TextStyle get linkText => poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.linkText, // Updated to use gradient start color
  );

  static TextStyle get bodyText => poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );

  static TextStyle get captionText => poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );
}
