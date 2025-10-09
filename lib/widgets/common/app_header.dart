import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';
import '../../config/constants.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? padding;
  final double titleFontSize;
  final double subtitleFontSize;
  final FontWeight titleFontWeight;
  final FontWeight subtitleFontWeight;
  final Color titleColor;
  final Color subtitleColor;
  final bool showLogo; // Option to show/hide logo

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.textAlign = TextAlign.center,
    this.padding,
    this.titleFontSize = 28.0, // Updated to match design
    this.subtitleFontSize = 16.0, // Updated to match design
    this.titleFontWeight = FontWeight.w600,
    this.subtitleFontWeight = FontWeight.w400,
    this.titleColor = AppColors.primaryText, // Updated to use theme color
    this.subtitleColor = AppColors.secondaryText, // Updated to use theme color
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          if (showLogo) ...[
            // Logo container with white background exactly like the design
            SizedBox(
              width: 128,
              height: 128,
              child:Image.asset(
                  'assets/images/logo.png',
                  
                ),
            ),
          ],
         
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: AppTextStyles.pageSubtitle,
              textAlign: textAlign,
            ),
          ],
        ],
      );
  }
}
