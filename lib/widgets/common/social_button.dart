import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../config/constants.dart';

class SocialButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final Color color;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color borderColor;
  final Color backgroundColor;
  final String? tooltip;

  const SocialButton({
    super.key,
    this.icon,
    this.imagePath,
    required this.color,
    required this.onPressed,
    this.size = 48.0,
    this.iconSize = 20.0,
    this.borderColor = AppColors.googleButtonBorder, // Updated default
    this.backgroundColor = Colors.white,
    this.tooltip,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided');

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Center(
            child: imagePath != null
                ? Image.asset(
                    imagePath!,
                    width: iconSize + 4,
                    height: iconSize + 4,
                  )
                : FaIcon(
                    icon!,
                    size: iconSize,
                    color: color,
                  ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      child = Tooltip(
        message: tooltip!,
        child: child,
      );
    }

    return child;
  }
}

// Predefined social buttons for common use cases
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return SocialButton(
      imagePath: 'assets/images/google-logo.png',
      color: const Color(0xFF4285F4),
      onPressed: onPressed,
      size: size,
      tooltip: 'Sign in with Google',
    );
  }
}

class FacebookSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const FacebookSignInButton({
    super.key,
    required this.onPressed,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return SocialButton(
      icon: FontAwesomeIcons.facebookF,
      color: const Color(0xFF1877F2),
      onPressed: onPressed,
      size: size,
      tooltip: 'Sign in with Facebook',
    );
  }
}
