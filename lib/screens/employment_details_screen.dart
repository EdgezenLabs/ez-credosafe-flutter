import 'package:flutter/material.dart';
import '../utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/loan_application_provider.dart';
import '../providers/loan_status_provider.dart';
import 'application_success_screen.dart';

class EmploymentDetailsScreen extends StatefulWidget {
  final String loanType;
  final String purpose;
  final String applicants;
  final String firstName;
  final String email;
  final PlatformFile? aadhaarFile;
  final PlatformFile? panFile;
  final double amount;
  final String tenure;
  final String residentialStatus;

  const EmploymentDetailsScreen({
    Key? key,
    required this.loanType,
    required this.purpose,
    required this.applicants,
    required this.firstName,
    required this.email,
    this.aadhaarFile,
    this.panFile,
    required this.amount,
    required this.tenure,
    required this.residentialStatus,
  }) : super(key: key);

  @override
  State<EmploymentDetailsScreen> createState() => _EmploymentDetailsScreenState();
}

class _EmploymentDetailsScreenState extends State<EmploymentDetailsScreen> {
  String? selectedStatus;
  bool isSubmitting = false;

  final List<String> statusOptions = [
    'Full-time employed',
    'Part-time employed',
    'Work at home',
    'Self employed',
    'Unemployed',
    'Retired',
    'Student',
  ];

  // Map display values to API values
  String _mapEmploymentTypeToApi(String displayValue) {
    switch (displayValue) {
      case 'Full-time employed':
      case 'Part-time employed':
        return 'salaried';
      case 'Self employed':
      case 'Work at home':
        return 'self_employed';
      case 'Unemployed':
      case 'Retired':
      case 'Student':
        return 'self_employed'; // Map to self_employed as fallback
      default:
        return 'salaried';
    }
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
          child: Column(
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: 10),

              // White Container with Form
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Color(0xFF300700),
                            ),
                            children: [
                              TextSpan(text: 'Employment '),
                              TextSpan(
                                text: 'Details',
                                style: TextStyle(
                                  color: Color(0xFFDAB360),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          "Please fill your employment details\nbelow",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),

                      // Status Section
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF300700),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Status Options
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...statusOptions.map((status) => _buildOptionButton(
                                status,
                                selectedStatus == status,
                                () {
                                  setState(() {
                                    selectedStatus = status;
                                  });
                                },
                              )),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Proceed Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _handleProceed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB8935E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            disabledBackgroundColor: const Color(0xFFB8935E).withValues(alpha: 0.5),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Proceed',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
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

  Widget _buildOptionButton(String text, bool isSelected, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFF4E0) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFFDAB360) : const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFF300700) : const Color(0xFF666666),
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleProceed() async {
    AppLogger.debug('_handleProceed called'); // Debug
    if (selectedStatus == null) {
      AppLogger.debug('No employment status selected'); // Debug
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your employment status')),
      );
      return;
    }

    AppLogger.debug('Employment status selected: $selectedStatus'); // Debug
    setState(() {
      isSubmitting = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final loanProvider = Provider.of<LoanApplicationProvider>(context, listen: false);

      // Get token from auth provider
      final token = authProvider.token;
      AppLogger.debug('Token: ${token != null ? "Available" : "Null"}'); // Debug
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login first')),
          );
        }
        setState(() {
          isSubmitting = false;
        });
        return;
      }

      AppLogger.debug('Calling applyForLoan API...'); // Debug
      AppLogger.debug('Selected status: $selectedStatus'); // Debug
      
      // Map employment type to API value
      final apiEmploymentType = _mapEmploymentTypeToApi(selectedStatus!);
      AppLogger.debug('Mapped employment type: $apiEmploymentType'); // Debug
      
      // Apply for loan
      final success = await loanProvider.applyForLoan(
        token: token,
        loanType: widget.loanType,
        requestedAmount: widget.amount,
        purpose: widget.purpose,
        employmentType: apiEmploymentType,
        monthlyIncome: 50000, // Default value, should be collected in a previous screen
        existingEmis: 0,
      );

      AppLogger.debug('applyForLoan result: $success'); // Debug
      if (!success || loanProvider.error != null) {
        AppLogger.debug('applyForLoan error: ${loanProvider.error}'); // Debug
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${loanProvider.error}')),
          );
        }
        setState(() {
          isSubmitting = false;
        });
        return;
      }

      // Get application ID from the response
      final applicationId = loanProvider.currentApplicationId;
      AppLogger.debug('Application ID: $applicationId'); // Debug
      if (applicationId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: No application ID received')),
          );
        }
        setState(() {
          isSubmitting = false;
        });
        return;
      }

      // Upload Aadhaar document if provided
      if (widget.aadhaarFile != null) {
        AppLogger.debug('Uploading Aadhaar document...'); // Debug
        final aadhaarSuccess = await loanProvider.uploadDocument(
          token: token,
          applicationId: applicationId,
          documentType: 'aadhaar',
          file: widget.aadhaarFile!,
        );

        AppLogger.debug('Aadhaar upload result: $aadhaarSuccess'); // Debug
        if (!aadhaarSuccess || loanProvider.error != null) {
          AppLogger.debug('Aadhaar upload error: ${loanProvider.error}'); // Debug
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error uploading Aadhaar: ${loanProvider.error}')),
            );
          }
          setState(() {
            isSubmitting = false;
          });
          return;
        }
      } else {
        AppLogger.debug('No Aadhaar file to upload, skipping...'); // Debug
      }

      // Upload PAN document if provided
      if (widget.panFile != null) {
        AppLogger.debug('Uploading PAN document...'); // Debug
        final panSuccess = await loanProvider.uploadDocument(
          token: token,
          applicationId: applicationId,
          documentType: 'pan',
          file: widget.panFile!,
        );

        AppLogger.debug('PAN upload result: $panSuccess'); // Debug
        if (!panSuccess || loanProvider.error != null) {
          AppLogger.debug('PAN upload error: ${loanProvider.error}'); // Debug
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error uploading PAN: ${loanProvider.error}')),
            );
          }
          setState(() {
            isSubmitting = false;
          });
          return;
        }
      } else {
        AppLogger.debug('No PAN file to upload, skipping...'); // Debug
      }

      setState(() {
        isSubmitting = false;
      });

      AppLogger.debug('All operations successful, navigating to success screen'); // Debug
      // Navigate to Success Screen only if everything succeeded
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ApplicationSuccessScreen(),
          ),
        );
      }
    } catch (e) {
      AppLogger.debug('Exception in _handleProceed: $e'); // Debug
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      setState(() {
        isSubmitting = false;
      });
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
            'Are you sure you want to sign out? Your current progress will be lost.',
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
}
