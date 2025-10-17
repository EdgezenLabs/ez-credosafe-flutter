import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../models/loan_status.dart';
import '../../providers/loan_status_provider.dart';
import '../../providers/auth_provider.dart';
import 'loan_type_selection_screen.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationStatusScreen> createState() => _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.goldenGradient,
        ),
        child: SafeArea(
          child: Consumer<LoanStatusProvider>(
            builder: (context, loanProvider, child) {
              if (loanProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }

              if (loanProvider.error != null) {
                return Center(
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
                        'Error loading application status',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loanProvider.error!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          final authProvider = context.read<AuthProvider>();
                          loanProvider.refreshLoanStatus(authProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppConstants.primaryText,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final pendingApplications = loanProvider.loanStatus?.pendingApplications ?? [];
              if (pendingApplications.isEmpty) {
                return const Center(
                  child: Text(
                    'No pending applications found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Applications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showSignOutDialog(context);
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 32,
                          ),
                          tooltip: 'Sign Out',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    // Application Count
                    Text(
                      '${pendingApplications.length} ${pendingApplications.length == 1 ? "Application" : "Applications"}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // List of Application Cards
                    ...pendingApplications.map((application) => 
                      _buildApplicationCard(application)
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Refresh Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Refresh status
                          final authProvider = context.read<AuthProvider>();
                          loanProvider.refreshLoanStatus(authProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                        child: const Text(
                          'Refresh Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoanTypeSelectionScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFDAB360),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildApplicationCard(PendingApplication application) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loan Type and Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  application.loanType,
                  style: const TextStyle(
                    color: AppConstants.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Text(
                '₹${application.requestedAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFFDAB360),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Application ID
          Text(
            'ID: ${application.applicationId.substring(0, 8)}...',
            style: TextStyle(
              color: AppConstants.primaryText.withValues(alpha: 0.6),
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          
          // Application Date
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: AppConstants.primaryText.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                'Applied on ${application.applicationDate ?? application.submittedDate}',
                style: TextStyle(
                  color: AppConstants.primaryText.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Progress Steps
          if (application.progressSteps != null && application.currentStep != null) ...[
            _buildProgressIndicator(application.progressSteps!, application.currentStep!),
            const SizedBox(height: 12),
          ],
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(application.status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              application.status.toUpperCase().replaceAll('_', ' '),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(List<String> steps, int currentStep) {
    return Column(
      children: [
        // Progress dots and line
        Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep - 1;
            
            return Expanded(
              child: Row(
                children: [
                  // Dot
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted || isCurrent
                          ? const Color(0xFFDAB360)
                          : const Color(0xFFCCCCCC),
                    ),
                  ),
                  // Line (not for last item)
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted
                            ? const Color(0xFFDAB360)
                            : const Color(0xFFCCCCCC),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        
        // Step labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep - 1;
            
            return Expanded(
              child: Text(
                steps[index],
                textAlign: index == 0 
                    ? TextAlign.left 
                    : (index == steps.length - 1 ? TextAlign.right : TextAlign.center),
                style: TextStyle(
                  fontSize: 10,
                  color: isCompleted || isCurrent
                      ? const Color(0xFFDAB360)
                      : const Color(0xFF999999),
                  fontWeight: isCompleted || isCurrent
                      ? FontWeight.w600
                      : FontWeight.normal,
                  fontFamily: 'Poppins',
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'under review':
        return Colors.blue;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _signOut(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final loanProvider = context.read<LoanStatusProvider>();
    
    // Clear loan status data
    loanProvider.reset();
    
    // Sign out user
    await authProvider.logout();
    
    // Navigate to login screen
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}