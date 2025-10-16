import 'package:flutter/material.dart';
import '../utils/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../config/constants.dart';
import '../models/loan_status.dart';
import '../providers/loan_status_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/common/gradient_button.dart';
import 'loan_type_selection_screen.dart';
import 'package:web/web.dart' as web;

class LoanStatusScreen extends StatefulWidget {
  const LoanStatusScreen({Key? key}) : super(key: key);

  @override
  State<LoanStatusScreen> createState() => _LoanStatusScreenState();
}

class _LoanStatusScreenState extends State<LoanStatusScreen> {
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
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFDAB360),
              Color(0xFF906C2A),
              Color(0xFF8C6829),
            ],
            stops: [0.0, 0.8317, 1.0],
          ),
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
                        'Error loading loan status',
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
                      GradientButton(
                        onPressed: () {
                          final authProvider = context.read<AuthProvider>();
                          loanProvider.refreshLoanStatus(authProvider);
                        },
                        text: 'Retry',
                        icon: Icons.refresh,
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

              return Column(
                children: [
                  // Header
                  _buildHeader(context),
                  const SizedBox(height: 20),

                  // White Container with Loan Status
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            // Title
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF300700),
                                ),
                                children: [
                                  TextSpan(text: 'Loan '),
                                  TextSpan(
                                    text: 'Status',
                                    style: TextStyle(
                                      color: Color(0xFFDAB360),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),

                            // All Progress Cards
                            ...pendingApplications.map((application) => 
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: _buildProgressCard(application),
                              ),
                            ),
                            
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.goldenGradient,
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoanTypeSelectionScreen(),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
            ),
            child: const ClipOval(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 15),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 3),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Text(
                      authProvider.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Logout Icon
          InkWell(
            onTap: () => _showSignOutDialog(context),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(PendingApplication application) {
    final progressSteps = application.progressSteps ?? ['Applied', 'Documents', 'Verification', 'Approval'];
    final documents = application.documents ?? [];
    
    // Calculate actual current step based on documents
    int currentStep = application.currentStep ?? 1;
    
    // If documents are uploaded, ensure we're at least at step 2 (Documents completed)
    if (documents.isNotEmpty && currentStep < 2) {
      currentStep = 2;
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFDAB360),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Application Header
          _buildApplicationHeader(application),
          const SizedBox(height: 30),

          // Section 1: Progress Tracker
          _buildProgressSection(progressSteps, currentStep),
          const SizedBox(height: 30),

          // Section 2: Application Documents
          _buildDocumentsSection(application.applicationId, documents),
          const SizedBox(height: 30),

          // Section 3: Loan Acceptance / Status
          _buildLoanAcceptanceSection(application),
        ],
      ),
    );
  }

  Widget _buildApplicationHeader(PendingApplication application) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.goldenGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                application.loanType.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.access_time,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              'Application ID: ${application.applicationId.substring(0, 8)}...',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection(List<String> progressSteps, int currentStep) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Application Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressIndicator(progressSteps, currentStep),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection(String applicationId, List<LoanDocument> documents) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Application Documents',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _showDocumentUploadDialog(context, applicationId);
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                  size: 28,
                ),
                tooltip: 'Upload Documents',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (documents.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No documents uploaded yet. Please upload required documents to proceed.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange[900],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${documents.length} document(s) uploaded',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[900],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...documents.map((doc) => _buildDocumentTile(doc)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLoanAcceptanceSection(PendingApplication application) {
    final status = application.status.toLowerCase();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.approval,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Loan Acceptance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Status Badge
          _buildStatusBadge(status),
          const SizedBox(height: 16),
          
          // Status Description
          _buildStatusDescription(status),
          const SizedBox(height: 20),
          
          // Actions
          if (status == 'pending' || status == 'under review')
            Column(
              children: [
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Need to make changes?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 12),
                GradientButton(
                  onPressed: () {
                    _showCancelDialog(context, application.applicationId);
                  },
                  text: 'Cancel Application',
                  icon: Icons.cancel_outlined,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    IconData badgeIcon;
    String displayText;
    
    switch (status) {
      case 'approved':
        badgeColor = Colors.green;
        badgeIcon = Icons.check_circle;
        displayText = 'APPROVED';
        break;
      case 'rejected':
        badgeColor = Colors.red;
        badgeIcon = Icons.cancel;
        displayText = 'REJECTED';
        break;
      case 'under review':
        badgeColor = Colors.blue;
        badgeIcon = Icons.rate_review;
        displayText = 'UNDER REVIEW';
        break;
      default:
        badgeColor = Colors.orange;
        badgeIcon = Icons.pending;
        displayText = 'PENDING';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            color: badgeColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: badgeColor,
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDescription(String status) {
    String description;
    
    switch (status) {
      case 'approved':
        description = 'Congratulations! Your loan application has been approved. You will receive further instructions via email.';
        break;
      case 'rejected':
        description = 'Unfortunately, your loan application has been rejected. Please contact support for more information.';
        break;
      case 'under review':
        description = 'Your application is currently being reviewed by our team. We will notify you once the review is complete.';
        break;
      default:
        description = 'Your application is pending. Please ensure all required documents are uploaded for faster processing.';
    }
    
    return Text(
      description,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
        fontFamily: 'Poppins',
        height: 1.5,
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
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted || isCurrent
                          ? const Color(0xFF8B4513)
                          : const Color(0xFFCCCCCC),
                    ),
                  ),
                  // Line (not for last item)
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted
                            ? const Color(0xFF8B4513)
                            : const Color(0xFFCCCCCC),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        
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
                  fontSize: 11,
                  color: isCompleted || isCurrent
                      ? const Color(0xFF8B4513)
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

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                // Navigate to home
              }),
              _buildNavItem(Icons.qr_code_scanner_outlined, 'Scan', false, () {
                // Navigate to scan
              }),
              _buildNavItem(Icons.mail_outline, 'Message', false, () {
                // Navigate to messages
              }),
              _buildNavItem(Icons.settings_outlined, 'Settings', false, () {
                // Navigate to settings
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFDAB360) : Colors.white,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFDAB360) : Colors.white,
              fontSize: 11,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String applicationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Cancel Application',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel your loan application? This action cannot be undone.',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'No, Keep It',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelApplication(context, applicationId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _cancelApplication(BuildContext context, String applicationId) async {
    final authProvider = context.read<AuthProvider>();
    final loanProvider = context.read<LoanStatusProvider>();
    
    // Get token
    final token = authProvider.token;
    if (token == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication required. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // Call API to cancel application (provider handles loading state)
      await loanProvider.cancelLoanApplication(token, applicationId, authProvider);

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Application cancelled successfully',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error cancelling application: $e',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
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

  Widget _buildDocumentTile(LoanDocument doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Document icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFDAB360).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description,
              color: Color(0xFFDAB360),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Document info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.documentType.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doc.fileName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666666),
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // View icon
          IconButton(
            onPressed: () {
              _viewDocument(doc);
            },
            icon: const Icon(
              Icons.visibility,
              color: AppColors.primary,
              size: 20,
            ),
            tooltip: 'View Document',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _viewDocument(LoanDocument doc) async {
    // Show dialog with view and download options
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            doc.documentType.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File: ${doc.fileName}',
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${doc.status}',
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 8),
              if (doc.uploadedAt.isNotEmpty)
                Text(
                  'Uploaded: ${doc.uploadedAt}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                    fontFamily: 'Poppins',
                  ),
                ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleViewDocument(doc.documentId);
              },
              icon: const Icon(Icons.visibility, color: AppColors.primary),
              label: const Text(
                'View',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.primary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleDownloadDocument(doc.documentId, doc.fileName);
              },
              icon: const Icon(Icons.download, color: AppColors.primary),
              label: const Text(
                'Download',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleViewDocument(String documentId) async {
    final stateContext = context;
    
    if (!mounted) return;
    
    try {
      // Show loading
      showDialog(
        context: stateContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDAB360)),
            ),
          );
        },
      );

      final authProvider = stateContext.read<AuthProvider>();
      final loanProvider = stateContext.read<LoanStatusProvider>();
      final token = authProvider.token;

      if (token == null) {
        if (!mounted) return;
        Navigator.of(stateContext).pop();
        ScaffoldMessenger.of(stateContext).showSnackBar(
          const SnackBar(
            content: Text(
              'Authentication error. Please login again.',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final url = await loanProvider.viewDocument(
        token: token,
        documentId: documentId,
      );

      if (!mounted) return;
      if (!stateContext.mounted) return;

      Navigator.of(stateContext).pop(); // Close loading

      if (url != null) {
        // Open URL in browser or show in web view
        await _openUrl(url);
      } else {
        ScaffoldMessenger.of(stateContext).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to view document. ${loanProvider.error ?? "Unknown error"}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      AppLogger.debug('Exception in _handleViewDocument: $e');
      if (!mounted) return;
      if (!stateContext.mounted) return;
      if (Navigator.canPop(stateContext)) {
        Navigator.of(stateContext).pop();
      }
      ScaffoldMessenger.of(stateContext).showSnackBar(
        SnackBar(
          content: Text(
            'Error viewing document: ${e.toString()}',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleDownloadDocument(String documentId, String fileName) async {
    final stateContext = context;
    
    if (!mounted) return;
    
    try {
      // Show loading
      showDialog(
        context: stateContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDAB360)),
            ),
          );
        },
      );

      final authProvider = stateContext.read<AuthProvider>();
      final loanProvider = stateContext.read<LoanStatusProvider>();
      final token = authProvider.token;

      if (token == null) {
        if (!mounted) return;
        if (!stateContext.mounted) return;
        Navigator.of(stateContext).pop();
        ScaffoldMessenger.of(stateContext).showSnackBar(
          const SnackBar(
            content: Text(
              'Authentication error. Please login again.',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final url = await loanProvider.downloadDocument(
        token: token,
        documentId: documentId,
      );

      if (!mounted) return;
      if (!stateContext.mounted) return;

      Navigator.of(stateContext).pop(); // Close loading

      if (url != null) {
        // Open download URL
        await _openUrl(url);
        
        if (!mounted) return;
        if (!stateContext.mounted) return;
        
        ScaffoldMessenger.of(stateContext).showSnackBar(
          SnackBar(
            content: Text(
              'Downloading $fileName...',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(stateContext).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to download document. ${loanProvider.error ?? "Unknown error"}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      AppLogger.debug('Exception in _handleDownloadDocument: $e');
      if (!mounted) return;
      if (!stateContext.mounted) return;
      if (Navigator.canPop(stateContext)) {
        Navigator.of(stateContext).pop();
      }
      ScaffoldMessenger.of(stateContext).showSnackBar(
        SnackBar(
          content: Text(
            'Error downloading document: ${e.toString()}',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openUrl(String url) async {
    // For web, we can use html package or window.open
    // For mobile, we can use url_launcher package
    if (kIsWeb) {
      // Use JavaScript to open URL in new tab
      web.window.open(url, '_blank');
    } else {
      // For mobile, you would use url_launcher
      // await launchUrl(Uri.parse(url));
      AppLogger.debug('Open URL on mobile: $url');
    }
  }

  void _showDocumentUploadDialog(BuildContext context, String applicationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Upload Documents',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upload your Aadhaar and PAN documents',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24),
              // Aadhaar upload button
              _buildUploadButton(
                context,
                'Aadhaar Card',
                Icons.credit_card,
                () => _uploadDocument(context, applicationId, 'aadhaar'),
              ),
              const SizedBox(height: 12),
              // PAN upload button
              _buildUploadButton(
                context,
                'PAN Card',
                Icons.account_balance_wallet,
                () => _uploadDocument(context, applicationId, 'pan'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUploadButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFDAB360),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFDAB360).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFDAB360),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const Icon(
              Icons.upload_file,
              color: Color(0xFFDAB360),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _uploadDocument(BuildContext context, String applicationId, String documentType) async {
    AppLogger.debug('_uploadDocument called - NOT closing dialog yet');
    
    try {
      AppLogger.debug('Starting file picker for document type: $documentType');
      
      // Pick file using file_picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true, // Important for web
      );

      AppLogger.debug('File picker result: ${result?.files.length ?? 0} files selected');

      if (result == null || result.files.isEmpty) {
        // User cancelled the picker
        AppLogger.debug('User cancelled file picker');
        // Close the upload type selection dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      final file = result.files.first;
      AppLogger.debug('Selected file: ${file.name}, size: ${file.size} bytes');

      // Validate file size (max 5MB)
      if (file.size > 5 * 1024 * 1024) {
        AppLogger.debug('File size exceeds limit: ${file.size} bytes');
        if (context.mounted) {
          Navigator.of(context).pop(); // Close upload type dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'File size must be less than 5MB',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      AppLogger.debug('Context mounted check: ${context.mounted}');
      
      // Close the upload type selection dialog first
      if (context.mounted) {
        AppLogger.debug('Closing upload type dialog');
        Navigator.of(context).pop();
      }
      
      // Small delay to ensure dialog is closed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Show confirmation dialog with file preview
      AppLogger.debug('About to show confirmation dialog');
      if (context.mounted) {
        AppLogger.debug('Context is mounted, calling _showFileConfirmationDialog');
        _showFileConfirmationDialog(context, applicationId, documentType, file);
      } else {
        AppLogger.debug('ERROR: Context is not mounted!');
      }

    } catch (e) {
      AppLogger.debug('Exception in _uploadDocument (file picking): $e');
      AppLogger.debug('Stack trace: ${StackTrace.current}');
      
      if (context.mounted) {
        Navigator.of(context).pop(); // Close upload type dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error selecting file: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFileConfirmationDialog(
    BuildContext context,
    String applicationId,
    String documentType,
    PlatformFile file,
  ) {
    AppLogger.debug('_showFileConfirmationDialog called');
    AppLogger.debug('File: ${file.name}, Document Type: $documentType, App ID: $applicationId');
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        AppLogger.debug('Building confirmation dialog...');
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Confirm ${documentType.toUpperCase()} Upload',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected File:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFDAB360),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insert_drive_file,
                      color: Color(0xFFDAB360),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(file.size / 1024).toStringAsFixed(2)} KB',
                            style: const TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Do you want to upload this file?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                AppLogger.debug('Cancel button clicked');
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            GradientButton(
              onPressed: () {
                AppLogger.debug('Submit button clicked in confirmation dialog');
                AppLogger.debug('Closing confirmation dialog');
                Navigator.of(dialogContext).pop();
                AppLogger.debug('Calling _performUpload');
                // No need to pass context, _performUpload will use state's context
                _performUpload(applicationId, documentType, file);
              },
              text: 'Submit',
              icon: Icons.upload_file,
              isCompact: true,
            ),
          ],
        );
      },
    );
  }

  void _performUpload(
    String applicationId,
    String documentType,
    PlatformFile file,
  ) async {
    AppLogger.debug('=== _performUpload CALLED ===');
    AppLogger.debug('Application ID: $applicationId');
    AppLogger.debug('Document Type: $documentType');
    AppLogger.debug('File: ${file.name}');
    
    // Add a small delay to allow dialog to close properly
    await Future.delayed(const Duration(milliseconds: 150));
    
    // Use widget's mounted property instead of context.mounted
    AppLogger.debug('After delay, widget mounted: $mounted');
    
    if (!mounted) {
      AppLogger.debug('ERROR: Widget is not mounted in _performUpload after delay');
      return;
    }
    
    // Use the state's context, not the dialog's context
    final stateContext = context;
    
    if (!stateContext.mounted) return;
    
    try {
      AppLogger.debug('Showing loading dialog');
      // Show loading indicator
      showDialog(
        context: stateContext,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDAB360)),
            ),
          );
        },
      );

      // Get providers
      final authProvider = stateContext.read<AuthProvider>();
      final loanProvider = stateContext.read<LoanStatusProvider>();
      final token = authProvider.token;

      AppLogger.debug('Token available: ${token != null}');
      AppLogger.debug('Application ID: $applicationId');

      if (token == null) {
        AppLogger.debug('Token is null, showing error');
        if (!mounted) return;
        if (!stateContext.mounted) return;
        Navigator.of(stateContext).pop(); // Close loading dialog
        ScaffoldMessenger.of(stateContext).showSnackBar(
          const SnackBar(
            content: Text(
              'Authentication error. Please login again.',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      AppLogger.debug('Calling uploadDocument API...');
      // Upload document using API service
      final uploadResult = await loanProvider.uploadDocument(
        token: token,
        applicationId: applicationId,
        documentType: documentType,
        file: file,
      );

      AppLogger.debug('Upload result: $uploadResult');

      if (!mounted) return;
      if (!stateContext.mounted) return;

      // Close loading dialog
      Navigator.of(stateContext).pop();
      AppLogger.debug('Loading dialog closed');

      if (uploadResult != null) {
        AppLogger.debug('Upload successful, showing success message');
        // Show success message
        ScaffoldMessenger.of(stateContext).showSnackBar(
          SnackBar(
            content: Text(
              '${documentType.toUpperCase()} uploaded successfully',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh loan status to show new document
        AppLogger.debug('Refreshing loan status...');
        await loanProvider.fetchLoanStatus(authProvider, forceRefresh: true);
        AppLogger.debug('Loan status refreshed');
      } else {
        AppLogger.debug('Upload failed, showing error message');
        // Show error message
        ScaffoldMessenger.of(stateContext).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to upload ${documentType.toUpperCase()}. ${loanProvider.error ?? "Unknown error"}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }

    } catch (e) {
      AppLogger.debug('Exception in _performUpload: $e');
      AppLogger.debug('Stack trace: ${StackTrace.current}');
      
      if (!mounted) return;
      if (!stateContext.mounted) return;
      // Close loading dialog if open
      if (Navigator.canPop(stateContext)) {
        Navigator.of(stateContext).pop();
      }

      // Show error message
      ScaffoldMessenger.of(stateContext).showSnackBar(
        SnackBar(
          content: Text(
            'Error uploading document: ${e.toString()}',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}