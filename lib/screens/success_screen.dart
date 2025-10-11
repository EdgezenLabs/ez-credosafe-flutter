import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/constants.dart';
import 'password_setup_screen.dart';

class SuccessScreen extends StatelessWidget {
  final String? email;
  
  const SuccessScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFAF4), // 0%
              Color(0xFFFFFBF6), // 50%
              Color(0xFFFFFCF5), // 100%
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  
                  // Logo and App Name together
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                      ),
                    
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Congratulations Text
                  Text(
                    'Congratulations!',
                    style: AppTextStyles.poppins(
                      fontSize: 31,
                      fontWeight: FontWeight.w600, // SemiBold
                      color: AppColors.primaryGold,
                      height: 1.0, // 100% line height
                      letterSpacing: 0.0, // 0% letter spacing
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Success Icon (green circle with check mark) - updated to match design
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF4CAF50), // Bright green border
                        width: 3,
                      ),
                      color: const Color(0xFFF9FDF9), // Very light green/white background
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_rounded, // Rounded check for smoother edges
                        size: 55,
                        color: Color(0xFF4CAF50), // Bright green check mark
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Success Text
                  Text(
                    'Success!',
                    style: AppTextStyles.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Success Message
                  Text(
                    'Congratulations! You have been\nsuccessfully authenticated',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Continue Button with gradient background
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFDAB360), // #DAB360 - 0%
                          Color(0xFF906C2A), // #906C2A - 83.17%
                          Color(0xFF8C6829), // #8C6829 - 100%
                        ],
                        stops: [0.0, 0.8317, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          // Navigate to password setup screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordSetupScreen(email: email ?? ''),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Continue',
                            style: AppTextStyles.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600, // SemiBold
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}