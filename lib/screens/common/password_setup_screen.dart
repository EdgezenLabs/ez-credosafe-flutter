import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_text_styles.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../utils/logger.dart';

class PasswordSetupScreen extends StatefulWidget {
  final String email;
  
  const PasswordSetupScreen({
    super.key,
    required this.email,
  });

  @override
  State<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isPasswordValid {
    final password = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    return password.isNotEmpty &&
           confirmPassword.isNotEmpty &&
           password == confirmPassword &&
           _isPasswordStrong(password);
  }

  bool _isPasswordStrong(String password) {
    // Password requirements: at least 8 characters, uppercase, lowercase, digit, special char
    return password.length >= 8 &&
           password.contains(RegExp(r'[A-Z]')) &&      // uppercase letter
           password.contains(RegExp(r'[a-z]')) &&      // lowercase letter
           password.contains(RegExp(r'[0-9]')) &&      // digit
           password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')); // special character
  }

  Future<void> _handleSubmit() async {
    if (!_isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please ensure passwords match and meet requirements')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.setPassword(widget.email, _newPasswordController.text);
      
      AppLogger.info('Password setup successful for email: ${widget.email}');
      
      if (mounted) {
        // Navigate to loans screen on successful password setup
        Navigator.of(context).pushReplacementNamed('/loan-dashboard');
      }
    } catch (e) {
      AppLogger.error('Password setup failed', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting up password: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildRequirementRow(String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            color: isMet ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            requirement,
            style: AppTextStyles.poppins(
              fontSize: 12,
              color: isMet ? Colors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFAF4),
              Color(0xFFFFFBF6),
              Color(0xFFFFFCF5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                  
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  
                  
                  // Create New Password Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Create ',
                          style: AppTextStyles.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        TextSpan(
                          text: 'new password',
                          style: AppTextStyles.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // New Password Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderColor),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _newPasswordController,
                      obscureText: !_newPasswordVisible,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'New password',
                        hintStyle: AppTextStyles.poppins(
                          fontSize: 14,
                          color: AppColors.hintText,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _newPasswordVisible 
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _newPasswordVisible = !_newPasswordVisible;
                            });
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Confirm Password Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderColor),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_confirmPasswordVisible,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Confirm new password',
                        hintStyle: AppTextStyles.poppins(
                          fontSize: 14,
                          color: AppColors.hintText,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPasswordVisible 
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  // Password requirements
                  if (_newPasswordController.text.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryGold.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password Requirements:',
                            style: AppTextStyles.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRequirementRow('At least 8 characters', _newPasswordController.text.length >= 8),
                          _buildRequirementRow('Uppercase letter (A-Z)', _newPasswordController.text.contains(RegExp(r'[A-Z]'))),
                          _buildRequirementRow('Lowercase letter (a-z)', _newPasswordController.text.contains(RegExp(r'[a-z]'))),
                          _buildRequirementRow('Number (0-9)', _newPasswordController.text.contains(RegExp(r'[0-9]'))),
                          _buildRequirementRow('Special character (!@#\$%^&*)', _newPasswordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))),
                        ],
                      ),
                    ),
                  ],

                  // Password match indicator
                  if (_confirmPasswordController.text.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _newPasswordController.text == _confirmPasswordController.text
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: _newPasswordController.text == _confirmPasswordController.text
                              ? Colors.green
                              : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _newPasswordController.text == _confirmPasswordController.text
                              ? 'Passwords match'
                              : 'Passwords do not match',
                          style: AppTextStyles.poppins(
                            fontSize: 12,
                            color: _newPasswordController.text == _confirmPasswordController.text
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 40),
                  
                  // Submit Button
                  Container(
                    width: double.infinity,
                    height: 50,
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
                        onTap: _isPasswordValid && !_isLoading ? _handleSubmit : null,
                        child: Center(
                          child: _isLoading 
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Submit',
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
    );
  }
}