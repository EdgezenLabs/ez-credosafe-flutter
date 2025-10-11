import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_text_styles.dart';
import '../config/constants.dart';
import '../providers/auth_provider.dart';
import '../utils/validation_utils.dart';
import '../widgets/index.dart';
import 'otp_verification_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Form keys for validation
  final _signInFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  
  // Sign In form controllers
  final _signInEmail = TextEditingController();
  final _signInPassword = TextEditingController();
  bool _signInLoading = false;
  bool _agreeToTerms = false;
  
  // Validation error states
  String? _emailError;
  String? _passwordError;
  bool _showValidationErrors = false;
  
  // Register form controllers
  final _registerEmail = TextEditingController();
  bool _registerLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    
    // Add listeners for real-time validation
    _signInEmail.addListener(_validateSignInForm);
    _signInPassword.addListener(_validateSignInForm);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmail.dispose();
    _signInPassword.dispose();
    _registerEmail.dispose();
    super.dispose();
  }

  // Real-time validation for sign in form
  void _validateSignInForm() {
    if (_showValidationErrors) {
      setState(() {
        _emailError = ValidationUtils.validateEmail(_signInEmail.text);
        _passwordError = ValidationUtils.validatePassword(_signInPassword.text);
      });
    }
  }

  // Validate form before submission
  bool _validateBeforeSubmit() {
    setState(() {
      _showValidationErrors = true;
      _emailError = ValidationUtils.validateEmail(_signInEmail.text);
      _passwordError = ValidationUtils.validatePassword(_signInPassword.text);
    });

    return _emailError == null && _passwordError == null;
  }

  // Show error snackbar
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Updated background color
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60), // Increased top spacing
              // Credosafe Header with logo
              AppHeader(
                title: 'CredoSafe',
                subtitle: _tabController.index == 0 
                    ? null // We'll build custom subtitle with highlighting
                    : null, // We'll build custom subtitle for register too
              ),
              
              // Custom subtitle with highlighting for Sign in page
              if (_tabController.index == 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        height: 1.0, // 100% line height
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text: 'Please ',
                          style: AppTextStyles.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            letterSpacing: 0,
                            color: const Color(0xFF300700), // Dark brown color
                          ),
                        ),
                        TextSpan(
                          text: 'Sign in',
                          style: AppTextStyles.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            letterSpacing: 0,
                            color: AppColors.primaryGold, // Golden highlight color
                          ),
                        ),
                        TextSpan(
                          text: ' to continue',
                          style: AppTextStyles.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            letterSpacing: 0,
                            color: const Color(0xFF300700), // Dark brown color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Custom subtitle for Register page
              if (_tabController.index == 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        height: 1.0, // 100% line height
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text: 'Create ',
                          style: AppTextStyles.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            letterSpacing: 0,
                            color: const Color(0xFF300700), // Dark brown color
                          ),
                        ),
                        TextSpan(
                          text: 'new account',
                          style: AppTextStyles.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            letterSpacing: 0,
                            color: AppColors.primaryGold, // Golden highlight color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 32), // Added spacing
              
              // Tab Bar with Triangle Pointer exactly like design
              CustomTabBar(
                tabs: const ['Sign in', 'Register'],
                tabController: _tabController,
                selectedColor: AppColors.primaryGold, // Ensure we use the exact color
                borderColor: AppColors.borderColor,
                height: 48.0, // Exact height from design
                onTabChanged: (index) {
                  // The tab controller handles the change
                },
              ),
                
              const SizedBox(height: 24), // Added spacing
              
              // Tab Content
              _tabController.index == 0 ? _buildSignInFormContent() : _buildRegisterFormContent(),
              
              const SizedBox(height: 40), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInFormContent() {
    return Form(
      key: _signInFormKey,
      child: FormContainer(
        padding: const EdgeInsets.all(0),
        spacing: 20.0, // Reduced spacing
        children: [
          // Email Address with icon and validation
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: '',
                hintText: 'Email address',
                controller: _signInEmail,
                keyboardType: TextInputType.emailAddress,
                showLabel: false,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.hintText,
                  size: 20,
                ),
                validator: (value) => ValidationUtils.validateEmail(value),
              ),
              if (_emailError != null && _showValidationErrors) ...[
                const SizedBox(height: 4),
                Text(
                  _emailError!,
                  style: AppTextStyles.captionText.copyWith(
                    color: AppColors.errorColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          
          // Password with icon and validation
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PasswordField(
                controller: _signInPassword,
                showLabel: false,
                hintText: 'Password',
                validator: (value) => ValidationUtils.validatePassword(value),
              ),
              if (_passwordError != null && _showValidationErrors) ...[
                const SizedBox(height: 4),
                Text(
                  _passwordError!,
                  style: AppTextStyles.captionText.copyWith(
                    color: AppColors.errorColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          
          // Forgot Password - right aligned
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () { 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              ),
              child: Text(
                'Forgot password?',
                style: AppTextStyles.linkText,
              ),
            ),
          ),
          
          // Terms Agreement Checkbox
          CustomCheckbox(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
            title: const TermsAndConditionsText(
              isChecked: true,
            ),
          ),
          
          // Sign In Button
          PrimaryButton(
            text: 'Sign in',
            onPressed: _agreeToTerms ? _handleSignIn : null,
            isLoading: _signInLoading,
            enabled: _agreeToTerms,
          ),
          
          // Divider text
          Center(
            child: Text(
              'other way to sign in',
              style: AppTextStyles.captionText,
            ),
          ),
          
          // Social Login Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleSignInButton(
                onPressed: () {
                  // TODO: Implement Google sign in
                },
              ),
              const SizedBox(width: 16),
              FacebookSignInButton(
                onPressed: () {
                  // TODO: Implement Facebook sign in
                },
              ),
            ],
          ),
          
          // Create Account Link
          Center(
            child: AuthLinkText(
              normalText: "Don't have an account? ",
              linkText: "Create Account",
              onTap: () {
                _tabController.animateTo(1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterFormContent() {
    return Form(
      key: _registerFormKey,
      child: FormContainer(
        padding: const EdgeInsets.all(0),
        spacing: 20.0,
        children: [
          Text(
            'Enter Email to send OTP',
            style: AppTextStyles.bodyText.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Email field for registration with icon and validation
          CustomTextField(
            label: '',
            hintText: 'Email address',
            controller: _registerEmail,
            keyboardType: TextInputType.emailAddress,
            showLabel: false,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.hintText,
              size: 20,
            ),
            validator: (value) => ValidationUtils.validateEmail(value),
          ),
          
          // Send OTP Button
          PrimaryButton(
            text: 'Send OTP',
            onPressed: _handleSendOTP,
            isLoading: _registerLoading,
          ),
          
          // Sign In Link
          Center(
            child: AuthLinkText(
              normalText: "Already have an account? ",
              linkText: "Back to Sign in",
              onTap: () {
                _tabController.animateTo(0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    // Validate form before proceeding
    if (!_validateBeforeSubmit()) {
      _showErrorSnackBar('Please fix the errors above before continuing');
      return;
    }

    // Additional check for terms agreement
    if (!_agreeToTerms) {
      _showErrorSnackBar('Please agree to the terms and conditions');
      return;
    }

    setState(() => _signInLoading = true);
    
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.login(_signInEmail.text.trim(), _signInPassword.text.trim());
      
      if (mounted) {
        // Clear validation errors on successful login
        setState(() {
          _showValidationErrors = false;
          _emailError = null;
          _passwordError = null;
        });
        
        Navigator.pushReplacementNamed(context, '/loans');
      }
    } catch (e) {
      // Show specific error message for login failure
      if (mounted) {
        _showErrorSnackBar('Login failed. Please check your credentials and try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _signInLoading = false);
      }
    }
  }

  Future<void> _handleSendOTP() async {
    // Validate email before sending OTP
    final emailError = ValidationUtils.validateEmail(_registerEmail.text);
    if (emailError != null) {
      _showErrorSnackBar(emailError);
      return;
    }

    setState(() => _registerLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.sendOtp(_registerEmail.text.trim());
      
      if (mounted) {
        if (response.success) {
          // Navigate to OTP verification screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(email: _registerEmail.text.trim()),
            ),
          );
        } else {
          // Show error message
          _showErrorSnackBar(response.message.isNotEmpty 
              ? response.message 
              : 'Failed to send OTP. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to send OTP: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _registerLoading = false);
      }
    }
  }
}


