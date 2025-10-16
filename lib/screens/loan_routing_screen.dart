import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart'; // This now exports all design system files
import '../widgets/common/gradient_button.dart';
import '../providers/loan_status_provider.dart';
import '../providers/auth_provider.dart';
import 'loan_dashboard_screen.dart';
import 'loan_status_screen.dart';
import 'loan_type_selection_screen.dart';

class LoanRoutingScreen extends StatefulWidget {
  const LoanRoutingScreen({Key? key}) : super(key: key);

  @override
  State<LoanRoutingScreen> createState() => _LoanRoutingScreenState();
}

class _LoanRoutingScreenState extends State<LoanRoutingScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch loan status when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      context.read<LoanStatusProvider>().fetchLoanStatus(authProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LoanStatusProvider, AuthProvider>(
      builder: (context, loanProvider, authProvider, child) {
        // Check for authentication errors and redirect to login
        if (loanProvider.isAuthenticationError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }

        // Check role-based access for loan features
        if (!authProvider.hasLoanAccess) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: AppConstants.goldenGradient,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Access Denied',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'You do not have permission to access loan features.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Logged in as: ${authProvider.user?.email ?? "Unknown"}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Role: ${authProvider.user?.role ?? "Unknown"}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      GradientButton(
                        onPressed: () async {
                          // Logout and redirect to login
                          await authProvider.logout();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        text: 'Logout',
                        icon: Icons.logout,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (loanProvider.isLoading) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: AppConstants.goldenGradient,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading your loan information...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (loanProvider.error != null) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: AppConstants.goldenGradient,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Unable to load loan information',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loanProvider.error!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      GradientButton(
                        onPressed: () {
                          loanProvider.refreshLoanStatus(authProvider);
                        },
                        text: 'Try Again',
                        icon: Icons.refresh,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Determine which screen to show based on user status
        final loanStatus = loanProvider.loanStatus;
        if (loanStatus == null) {
          // If no loan status, show loan type selection as default
          return const LoanTypeSelectionScreen();
        }

        switch (loanStatus.userStatus.toLowerCase()) {
          case 'has_loan':
            // User has an active loan - show loan dashboard
            return const LoanDashboardScreen();
          
          case 'pending_application':
            // User has a pending application - show application status
            return const LoanStatusScreen();
          
          case 'new_user':
          default:
            // New user or unknown status - show loan type selection
            return const LoanTypeSelectionScreen();
        }
      },
    );
  }
}