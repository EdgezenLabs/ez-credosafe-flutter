import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../config/constants.dart';
import '../models/loan_status.dart';
import '../providers/loan_status_provider.dart';
import '../providers/auth_provider.dart';
import 'loan_type_selection_screen.dart';
import 'dart:html' as html show window;

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
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(height: 16),
                      Text(
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
                          color: Colors.white.withOpacity(0.8),
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
                            color: Colors.black.withOpacity(0.05),
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
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
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
                    color: Colors.white.withOpacity(0.8),
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
                color: Colors.white.withOpacity(0.2),
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
    final currentStep = application.currentStep ?? 1;
    final documents = application.documents ?? [];
    
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
          // Progress header text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Your loan program progress: ${application.loanType}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              // Document upload icon
              IconButton(
                onPressed: () {
                  _showDocumentUploadDialog(context, application.applicationId);
                },
                icon: const Icon(
                  Icons.upload_file,
                  color: Color(0xFFDAB360),
                  size: 28,
                ),
                tooltip: 'Upload Documents',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Progress Indicator
          _buildProgressIndicator(progressSteps, currentStep),
          
          const SizedBox(height: 30),

          // Documents Section (if any documents exist)
          if (documents.isNotEmpty) ...[
            const Text(
              'Uploaded Documents:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            ...documents.map((doc) => _buildDocumentTile(doc)),
            const SizedBox(height: 20),
          ],

          // Info text
          const Text(
            'If you want to do re-apply or edit your data, you can do it',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),

          // Cancel Application Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showCancelDialog(context, application.applicationId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8935E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Cancel Application',
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
            color: Colors.black.withOpacity(0.1),
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
              color: const Color(0xFFDAB360).withOpacity(0.1),
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
              color: Color(0xFFDAB360),
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
              icon: const Icon(Icons.visibility, color: Color(0xFFDAB360)),
              label: const Text(
                'View',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFFDAB360),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleDownloadDocument(doc.documentId, doc.fileName);
              },
              icon: const Icon(Icons.download, color: Color(0xFFDAB360)),
              label: const Text(
                'Download',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFFDAB360),
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
        if (mounted) {
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
        }
        return;
      }

      final url = await loanProvider.viewDocument(
        token: token,
        documentId: documentId,
      );

      if (!mounted) return;

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
      print('Exception in _handleViewDocument: $e');
      if (mounted) {
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
        if (mounted) {
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
        }
        return;
      }

      final url = await loanProvider.downloadDocument(
        token: token,
        documentId: documentId,
      );

      if (!mounted) return;

      Navigator.of(stateContext).pop(); // Close loading

      if (url != null) {
        // Open download URL
        await _openUrl(url);
        
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
      print('Exception in _handleDownloadDocument: $e');
      if (mounted) {
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
  }

  Future<void> _openUrl(String url) async {
    // For web, we can use html package or window.open
    // For mobile, we can use url_launcher package
    if (kIsWeb) {
      // Use JavaScript to open URL in new tab
      // ignore: avoid_web_libraries_in_flutter
      html.window.open(url, '_blank');
    } else {
      // For mobile, you would use url_launcher
      // await launchUrl(Uri.parse(url));
      print('Open URL on mobile: $url');
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
                color: const Color(0xFFDAB360).withOpacity(0.1),
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
    print('_uploadDocument called - NOT closing dialog yet');
    
    try {
      print('Starting file picker for document type: $documentType');
      
      // Pick file using file_picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true, // Important for web
      );

      print('File picker result: ${result?.files.length ?? 0} files selected');

      if (result == null || result.files.isEmpty) {
        // User cancelled the picker
        print('User cancelled file picker');
        // Close the upload type selection dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      final file = result.files.first;
      print('Selected file: ${file.name}, size: ${file.size} bytes');

      // Validate file size (max 5MB)
      if (file.size > 5 * 1024 * 1024) {
        print('File size exceeds limit: ${file.size} bytes');
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

      print('Context mounted check: ${context.mounted}');
      
      // Close the upload type selection dialog first
      if (context.mounted) {
        print('Closing upload type dialog');
        Navigator.of(context).pop();
      }
      
      // Small delay to ensure dialog is closed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Show confirmation dialog with file preview
      print('About to show confirmation dialog');
      if (context.mounted) {
        print('Context is mounted, calling _showFileConfirmationDialog');
        _showFileConfirmationDialog(context, applicationId, documentType, file);
      } else {
        print('ERROR: Context is not mounted!');
      }

    } catch (e) {
      print('Exception in _uploadDocument (file picking): $e');
      print('Stack trace: ${StackTrace.current}');
      
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
    print('_showFileConfirmationDialog called');
    print('File: ${file.name}, Document Type: $documentType, App ID: $applicationId');
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        print('Building confirmation dialog...');
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
                print('Cancel button clicked');
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
            ElevatedButton(
              onPressed: () {
                print('Submit button clicked in confirmation dialog');
                print('Closing confirmation dialog');
                Navigator.of(dialogContext).pop();
                print('Calling _performUpload');
                // No need to pass context, _performUpload will use state's context
                _performUpload(applicationId, documentType, file);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDAB360),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
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
    print('=== _performUpload CALLED ===');
    print('Application ID: $applicationId');
    print('Document Type: $documentType');
    print('File: ${file.name}');
    
    // Add a small delay to allow dialog to close properly
    await Future.delayed(const Duration(milliseconds: 150));
    
    // Use widget's mounted property instead of context.mounted
    print('After delay, widget mounted: $mounted');
    
    if (!mounted) {
      print('ERROR: Widget is not mounted in _performUpload after delay');
      return;
    }
    
    // Use the state's context, not the dialog's context
    final stateContext = context;
    
    try {
      print('Showing loading dialog');
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

      print('Token available: ${token != null}');
      print('Application ID: $applicationId');

      if (token == null) {
        print('Token is null, showing error');
        if (mounted) {
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
        }
        return;
      }

      print('Calling uploadDocument API...');
      // Upload document using API service
      final uploadResult = await loanProvider.uploadDocument(
        token: token,
        applicationId: applicationId,
        documentType: documentType,
        file: file,
      );

      print('Upload result: $uploadResult');

      if (!mounted) return;

      // Close loading dialog
      Navigator.of(stateContext).pop();
      print('Loading dialog closed');

      if (uploadResult != null) {
        print('Upload successful, showing success message');
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
        print('Refreshing loan status...');
        await loanProvider.fetchLoanStatus(authProvider, forceRefresh: true);
        print('Loan status refreshed');
      } else {
        print('Upload failed, showing error message');
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
      print('Exception in _performUpload: $e');
      print('Stack trace: ${StackTrace.current}');
      
      if (mounted) {
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
}