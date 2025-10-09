import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';
import '../../config/constants.dart';

class FormContainer extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const FormContainer({
    super.key,
    required this.children,
    this.padding,
    this.spacing = 24.0, // Increased spacing to match design
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: _buildChildrenWithSpacing(),
    );

    if (backgroundColor != null || borderRadius != null || border != null || boxShadow != null) {
      content = Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow,
        ),
        child: content,
      );
    }

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24.0),
      child: content,
    );
  }

  List<Widget> _buildChildrenWithSpacing() {
    if (children.isEmpty) return [];
    
    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }
    return spacedChildren;
  }
}

class AuthLinkText extends StatelessWidget {
  final String normalText;
  final String linkText;
  final VoidCallback onTap;
  final Color normalColor;
  final Color linkColor;
  final double fontSize;
  final FontWeight? linkFontWeight;
  final TextAlign textAlign;

  const AuthLinkText({
    super.key,
    required this.normalText,
    required this.linkText,
    required this.onTap,
    this.normalColor = AppColors.secondaryText, // Updated to use theme color
    this.linkColor = AppColors.linkText, // Updated to use theme color
    this.fontSize = 14.0,
    this.linkFontWeight = FontWeight.w500,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: AppTextStyles.bodyText.copyWith(
          color: normalColor,
          fontSize: fontSize,
        ),
        children: [
          TextSpan(text: normalText),
          WidgetSpan(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                linkText,
                style: AppTextStyles.linkText.copyWith(
                  fontSize: fontSize,
                  fontWeight: linkFontWeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TermsAndConditionsText extends StatelessWidget {
  final bool isChecked;
  final VoidCallback? onUserAgreementTap;
  final VoidCallback? onPrivacyPolicyTap;
  final Color textColor;
  final Color linkColor;
  final double fontSize;

  const TermsAndConditionsText({
    super.key,
    required this.isChecked,
    this.onUserAgreementTap,
    this.onPrivacyPolicyTap,
    this.textColor = AppColors.primaryText, // Updated to use theme color
    this.linkColor = AppColors.linkText, // Updated to use theme color
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyText.copyWith(
          color: textColor,
          fontSize: fontSize,
        ),
        children: [
          const TextSpan(text: "I've read and agreed to "),
          WidgetSpan(
            child: GestureDetector(
              onTap: onUserAgreementTap,
              child: Text(
                "User Agreement",
                style: AppTextStyles.linkText.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const TextSpan(text: " and "),
          WidgetSpan(
            child: GestureDetector(
              onTap: onPrivacyPolicyTap,
              child: Text(
                "Privacy Policy",
                style: AppTextStyles.linkText.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
