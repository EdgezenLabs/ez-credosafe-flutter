import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_text_styles.dart';
import '../config/constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/index.dart';
import 'login_screen.dart';

class EmailLinkSentScreen extends StatefulWidget {
  final String email;

  const EmailLinkSentScreen({
    super.key,
    required this.email,
  });

  @override
  State<EmailLinkSentScreen> createState() => _EmailLinkSentScreenState();
}

class _EmailLinkSentScreenState extends State<EmailLinkSentScreen> {
  bool _isResending = false;

  Future<void> _resendEmail() async {
    setState(() => _isResending = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.forgotPassword(widget.email);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Reset link sent successfully!',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.toString().replaceFirst('Exception: ', ''),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _backToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryText,
          ),
          onPressed: _backToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // App Header with logo
              const AppHeader(
                title: 'CredoSafe',
                subtitle: null,
              ),
              
              // Custom subtitle with highlighting
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                    children: [
                      TextSpan(
                        text: 'Check your ',
                        style: AppTextStyles.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          letterSpacing: 0,
                          color: const Color(0xFF300700),
                        ),
                      ),
                      TextSpan(
                        text: 'email',
                        style: AppTextStyles.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          letterSpacing: 0,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Email icon
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 40,
                  color: AppColors.primaryGold,
                ),
              ),

              // Instruction text
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'We\'ve sent a password reset link to:',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                ),
              ),

              // User email
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ),

              // Additional instructions
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Text(
                  'Click the link in your email to reset your password. If you don\'t see the email, check your spam folder.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                ),
              ),

              // Resend email button
              SecondaryButton(
                text: 'Resend Email',
                onPressed: _isResending ? null : _resendEmail,
                isLoading: _isResending,
                width: double.infinity,
              ),

              const SizedBox(height: 24),

              // Back to Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remember your password? ',
                    style: AppTextStyles.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  GestureDetector(
                    onTap: _backToLogin,
                    child: Text(
                      'Sign In',
                      style: AppTextStyles.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}