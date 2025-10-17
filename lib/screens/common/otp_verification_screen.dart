import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_text_styles.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import 'success_screen.dart';
import 'dart:async';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  
  const OTPVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  bool _isLoading = false;
  String _otpCode = '';
  Timer? _countdownTimer;
  int _countdownSeconds = 60;
  bool _canResend = false;
  
  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdownSeconds = 60;
      _canResend = false;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  bool get _isOTPComplete {
    return _otpCode.length == 6 && _otpCode.split('').every((digit) => digit.isNotEmpty);
  }

  Future<void> _verifyOTP() async {
    if (!_isOTPComplete) {
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.verifyOtp(widget.email, _otpCode);
      
      if (mounted) {
        if (response.success && response.token != null) {
          // OTP verified successfully - navigate to success screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessScreen(email: widget.email),
            ),
          );
        } else {
          // OTP verification failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      response.message.isNotEmpty 
                          ? response.message 
                          : 'Invalid OTP. Please try again.',
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
          // Clear the OTP input
          setState(() {
            _otpCode = '';
          });
        }
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
                    'Verification failed: ${e.toString()}',
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
        // Clear the OTP input on error
        setState(() {
          _otpCode = '';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.sendOtp(widget.email);
      
      if (mounted) {
        if (response.success) {
          // Clear current inputs and restart countdown
          setState(() {
            _otpCode = '';
          });
          _startCountdown();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      response.message.isNotEmpty 
                          ? response.message 
                          : 'OTP sent successfully!',
                      style: const TextStyle(fontSize: 14),
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      response.message.isNotEmpty 
                          ? response.message 
                          : 'Failed to send OTP. Please try again.',
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
                    'Failed to resend OTP: ${e.toString()}',
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
    }
  }

  String get _maskedEmail {
    final parts = widget.email.split('@');
    if (parts.length != 2) return widget.email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 4) {
      return '${username.substring(0, 1)}${'*' * (username.length - 1)}@$domain';
    } else {
      return '${username.substring(0, 4)}${'*' * (username.length - 4)}@$domain';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isLoading = _isLoading || authProvider.isLoading;
        
        return Scaffold(
          body: Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 
                              MediaQuery.of(context).padding.top - 
                              MediaQuery.of(context).padding.bottom - 48, // Account for padding
                  ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40), // Reduced from 60
                      
                      // Logo Section - Using actual logo image like login screen
                      SizedBox(
                        width: 100, // Reduced from 128
                        height: 100, // Reduced from 128
                        child: Image.asset(
                          'assets/images/logo.png',
                        ),
                      ),
                      const SizedBox(height: 24), // Reduced from 32
                      
                      
                      // Title
                      Text(
                        'Verification Code',
                        style: AppTextStyles.poppins(
                          fontSize: 22, // Reduced from 24
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12), // Reduced from 16
                  
                  // Subtitle with email
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.poppins(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'We send verification code to your email\nthat you registered, '),
                        TextSpan(
                          text: _maskedEmail,
                          style: AppTextStyles.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32), // Reduced from 50
                  
                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 50, // Reduced to fit 6 fields
                        height: 50, // Reduced to fit 6 fields
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: AppTextStyles.poppins(
                              fontSize: 20, // Reduced for smaller fields
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryText,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                // Move to next field
                                if (index < 5) { // Changed from 3 to 5 for 6 fields
                                  FocusScope.of(context).nextFocus();
                                }
                              }
                              
                              // Update OTP code
                              List<String> digits = _otpCode.split('');
                              while (digits.length < 6) { // Changed from 4 to 6
                                digits.add('');
                              }
                              digits[index] = value;
                              setState(() {
                                _otpCode = digits.join('');
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32), // Reduced from 50
                  
                  // Resend Section
                  Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.poppins(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                          ),
                          children: [
                            const TextSpan(
                              text: "If you didn't received any code\nplease click ",
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: _canResend ? _resendOTP : null,
                                child: Text(
                                  'resend',
                                  style: AppTextStyles.poppins(
                                    fontSize: 14,
                                    color: _canResend ? const Color(0xFFC29A48) : AppColors.hintText,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      if (!_canResend) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Resend in ${_countdownSeconds}s',
                          style: AppTextStyles.poppins(
                            fontSize: 12,
                            color: const Color(0xFFC29A48).withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  // Flexible spacing instead of Spacer
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1), // 10% of screen height
                  
                  // Confirm Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 24), // Reduced from 40
                    decoration: BoxDecoration(
                      gradient: _isOTPComplete 
                          ? AppColors.primaryGradient
                          : null,
                      color: _isOTPComplete ? null : AppColors.hintText,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _isOTPComplete ? [
                        BoxShadow(
                          color: AppColors.primaryGold.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ] : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _isOTPComplete && !isLoading ? _verifyOTP : null,
                        child: Container(
                          alignment: Alignment.center,
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Confirm',
                                  style: AppTextStyles.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ),
        );
      },
    );
  }
}
