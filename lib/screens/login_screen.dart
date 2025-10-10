import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_text_styles.dart';
import '../config/constants.dart';
import '../providers/auth_provider.dart';
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
  
  // Sign In form controllers
  final _signInEmail = TextEditingController();
  final _signInPassword = TextEditingController();
  bool _signInLoading = false;
  bool _agreeToTerms = false;
  
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmail.dispose();
    _signInPassword.dispose();
    _registerEmail.dispose();
    super.dispose();
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
    return FormContainer(
      padding: const EdgeInsets.all(0),
      spacing: 20.0, // Reduced spacing
      children: [
        // Email Address with icon
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
        ),
        
        // Password with icon
        PasswordField(
          controller: _signInPassword,
          showLabel: false,
          hintText: 'Password',
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
    );
  }

  Widget _buildRegisterFormContent() {
    return FormContainer(
      padding: const EdgeInsets.all(0),
      spacing: 20.0,
      children: [
        Text(
          'Enter Email to send OTP',
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        
        // Email field for registration with icon
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
    );
  }

  Future<void> _handleSignIn() async {
    if (_signInEmail.text.trim().isEmpty || _signInPassword.text.trim().isEmpty) {
      return;
    }

    setState(() => _signInLoading = true);
    
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.login(_signInEmail.text.trim(), _signInPassword.text.trim());
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/loans');
      }
    } catch (e) {
      // Login failed - handle silently or log for debugging
    } finally {
      if (mounted) {
        setState(() => _signInLoading = false);
      }
    }
  }

  Future<void> _handleSendOTP() async {
    if (_registerEmail.text.trim().isEmpty) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message.isNotEmpty 
                  ? response.message 
                  : 'Failed to send OTP. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _registerLoading = false);
      }
    }
  }
}


