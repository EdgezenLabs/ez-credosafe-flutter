import 'package:flutter/material.dart';
import '../../config/constants.dart';

/// Gradient Button Widget - Reusable button with golden gradient
class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isFullWidth;
  final double borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final bool isCompact;
  final bool isLoading;

  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isFullWidth = true,
    this.borderRadius = 12,
    this.padding,
    this.textStyle,
    this.isCompact = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPadding = isCompact
        ? const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 32, vertical: 14);

    final buttonTextStyle = textStyle ??
        (isCompact ? AppTypography.buttonSmall : AppTypography.button);

    return Container(
      width: isFullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: onPressed == null
            ? null
            : AppColors.goldenGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        color: onPressed == null ? AppColors.textDisabled : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed == null || isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? defaultPadding,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize:
                        isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: Colors.white,
                          size: isCompact ? 18 : 20,
                        ),
                        SizedBox(width: isCompact ? 8 : 12),
                      ],
                      Text(
                        text,
                        style: buttonTextStyle.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Outlined Gradient Button - Button with gradient border
class GradientOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isFullWidth;
  final double borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final bool isCompact;

  const GradientOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isFullWidth = true,
    this.borderRadius = 12,
    this.padding,
    this.textStyle,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPadding = isCompact
        ? const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 32, vertical: 14);

    final buttonTextStyle = textStyle ??
        (isCompact ? AppTypography.buttonSmall : AppTypography.button);

    return Container(
      width: isFullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: onPressed == null ? null : AppColors.goldenGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        margin: const EdgeInsets.all(2), // Border width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius - 2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius - 2),
            child: Container(
              padding: padding ?? defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.goldenGradient.createShader(bounds),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: isCompact ? 18 : 20,
                      ),
                    ),
                    SizedBox(width: isCompact ? 8 : 12),
                  ],
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.goldenGradient.createShader(bounds),
                    child: Text(
                      text,
                      style: buttonTextStyle.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon with Golden Gradient
class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const GradientIcon({
    Key? key,
    required this.icon,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppColors.goldenGradient.createShader(bounds),
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
