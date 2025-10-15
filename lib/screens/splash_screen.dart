import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../providers/auth_provider.dart';
import '../screens/reset_password_screen.dart';
import '../utils/url_helper.dart';
import '../utils/logger.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _animationController.forward();

    // Navigate to appropriate screen after delay
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Timer(const Duration(seconds: 3), () {
      // Check for reset password URL first (web only)
      if (kIsWeb) {
        try {
          final currentUrl = UrlHelper.getCurrentUrl();
          AppLogger.debug('Splash - Current URL: $currentUrl');
          
          if (currentUrl.contains('/reset-password') && currentUrl.contains('token=')) {
            final urlParams = UrlHelper.getUrlParameters();
            final token = urlParams['token'] ?? '';
            final email = urlParams['email'] ?? '';
            
            AppLogger.debug('Splash - Reset password URL detected');
            AppLogger.debug('Splash - Token: $token');
            
            if (token.isNotEmpty) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPasswordScreen(token: token, email: email),
                ),
              );
              return;
            }
          }
        } catch (e) {
          AppLogger.error('Splash - Error parsing URL', e);
        }
      }
      
      // Default navigation logic
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Navigate based on authentication status
      if (authProvider.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/loan-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 160,
      height: 160,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2), // Cream/off-white background
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    _buildLogo(),
                   
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
