import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/loan_status_provider.dart';
import 'residential_details_screen.dart';

class PersonalLoanApplicationScreen extends StatefulWidget {
  final String loanType;
  
  const PersonalLoanApplicationScreen({
    Key? key,
    required this.loanType,
  }) : super(key: key);

  @override
  State<PersonalLoanApplicationScreen> createState() => _PersonalLoanApplicationScreenState();
}

class _PersonalLoanApplicationScreenState extends State<PersonalLoanApplicationScreen> {
  String? selectedPurpose;
  String? selectedApplicants;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? selectedTenure;
  bool acceptedTerms = false;
  
  // File upload state - using PlatformFile for web compatibility
  PlatformFile? aadhaarFile;
  PlatformFile? panFile;

  final List<String> purposes = [
    'Purchase a Property',
    'Reference my home loan',
    'Both',
  ];

  final List<String> applicantOptions = [
    'Just me',
    '2 of us',
    '3+ People',
  ];

  final List<String> tenureOptions = ['12 Months', '24 Months', '36 Months'];

  @override
  void dispose() {
    firstNameController.dispose();
    emailController.dispose();
    amountController.dispose();
    super.dispose();
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
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
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
                                TextSpan(text: 'Personal '),
                                TextSpan(
                                  text: 'Loan',
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
                            "Let's get started! First tell us about\nyour personal loan needs.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // What would you like to do? (Required)
                        _buildSectionTitle('What would you like to do? (Required)'),
                        const SizedBox(height: 10),
                        ...purposes.map((purpose) => _buildOptionButton(
                          purpose,
                          selectedPurpose == purpose,
                          () {
                            setState(() {
                              selectedPurpose = purpose;
                            });
                          },
                        )),
                        const SizedBox(height: 20),

                        // How many people will be part of this application?
                        _buildSectionTitle('How many people will be part of this application?'),
                        const SizedBox(height: 10),
                        ...applicantOptions.map((option) => _buildOptionButton(
                          option,
                          selectedApplicants == option,
                          () {
                            setState(() {
                              selectedApplicants = option;
                            });
                          },
                        )),
                        const SizedBox(height: 20),

                        // What is your first name? (Required)
                        _buildSectionTitle('What is your first name? (Required)'),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: firstNameController,
                          hint: 'Sunil',
                        ),
                        const SizedBox(height: 20),

                        // Email address (Required)
                        _buildSectionTitle('Email address (Required)'),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: emailController,
                          hint: 'sunil.js@edgezenlabs.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // Please upload your Aadhaar Card (Optional)
                        _buildSectionTitle('Please upload your Aadhaar Card (Optional)'),
                        const SizedBox(height: 10),
                        _buildUploadButton(
                          aadhaarFile?.name ?? 'Upload',
                          Icons.upload_file,
                          () => _pickFile('aadhaar'),
                        ),
                        const SizedBox(height: 20),

                        // Please upload your PAN Card (Optional)
                        _buildSectionTitle('Please upload your PAN Card (Optional)'),
                        const SizedBox(height: 10),
                        _buildUploadButton(
                          panFile?.name ?? 'Upload',
                          Icons.upload_file,
                          () => _pickFile('pan'),
                        ),
                        const SizedBox(height: 20),

                        // Amount you want to loan
                        _buildSectionTitle('Amount you want to loan'),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: amountController,
                          hint: '15,000,000',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),

                        // Monthly Program
                        _buildSectionTitle('Monthly Program'),
                        const SizedBox(height: 10),
                        Row(
                          children: tenureOptions.map((tenure) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildTenureButton(
                                  tenure,
                                  selectedTenure == tenure,
                                  () {
                                    setState(() {
                                      selectedTenure = tenure;
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Terms and Conditions
                        Row(
                          children: [
                            Checkbox(
                              value: acceptedTerms,
                              onChanged: (value) {
                                setState(() {
                                  acceptedTerms = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFFDAB360),
                            ),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                    fontFamily: 'Poppins',
                                  ),
                                  children: [
                                    TextSpan(text: 'Accepted all of '),
                                    TextSpan(
                                      text: 'terms & Conditions',
                                      style: TextStyle(
                                        color: Color(0xFFDAB360),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Continue Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFDAB360), // #DAB360 at 0%
                                Color(0xFF906C2A), // #906C2A at 83.17%
                                Color(0xFF8C6829), // #8C6829 at 100%
                              ],
                              stops: [0.0, 0.8317, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _handleContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Continue',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF300700),
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildOptionButton(String text, bool isSelected, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              gradient: isSelected 
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFF4E0),
                      Color(0xFFFFF0D0),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF5F5F5),
                    ],
                  ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFC7A052) : const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF300700) : const Color(0xFF666666),
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF4E0),
            Color(0xFFFFF0D0),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC7A052),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF300700),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontFamily: 'Poppins',
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildUploadButton(String text, IconData icon, VoidCallback onTap) {
    final bool hasFile = text != 'Upload';
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 35),
        decoration: BoxDecoration(
          gradient: hasFile
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFF4E0),
                    Color(0xFFFFF0D0),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFF5F5F5),
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile ? const Color(0xFFC7A052) : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFDAB360),
                    Color(0xFFC7A052),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFile ? Icons.check_circle : icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: hasFile ? const Color(0xFF300700) : const Color(0xFF888888),
                fontFamily: 'Poppins',
                fontWeight: hasFile ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(String type) async {
    print('_pickFile called with type: $type'); // Debug
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      print('File picker result: ${result != null ? "Got result" : "Null result"}'); // Debug

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        print('Selected file: ${file.name}'); // Debug
        print('File size: ${file.size} bytes'); // Debug
        print('Has bytes: ${file.bytes != null}'); // Debug
        
        setState(() {
          if (type == 'aadhaar') {
            aadhaarFile = file;
            print('Aadhaar file stored successfully'); // Debug
          } else if (type == 'pan') {
            panFile = file;
            print('PAN file stored successfully'); // Debug
          }
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${file.name} selected successfully')),
          );
        }
      } else {
        print('No file selected or result is empty'); // Debug
      }
    } catch (e, stackTrace) {
      print('Error picking file: $e'); // Debug
      print('Stack trace: $stackTrace'); // Debug
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file. Please try again.')),
        );
      }
    }
  }

  Widget _buildTenureButton(String text, bool isSelected, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isSelected 
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFF4E0),
                    Color(0xFFFFF0D0),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFF5F5F5),
                  ],
                ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFFC7A052) : const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? const Color(0xFF300700) : const Color(0xFF666666),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (selectedPurpose == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select what you would like to do')),
      );
      return;
    }

    if (firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your first name')),
      );
      return;
    }

    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    // File uploads are now optional

    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter loan amount')),
      );
      return;
    }

    if (selectedTenure == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select monthly program')),
      );
      return;
    }

    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    // Navigate to Residential Details Screen with collected data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResidentialDetailsScreen(
          loanType: widget.loanType,
          purpose: selectedPurpose!,
          applicants: selectedApplicants!,
          firstName: firstNameController.text,
          email: emailController.text,
          aadhaarFile: aadhaarFile,
          panFile: panFile,
          amount: double.tryParse(amountController.text.replaceAll(',', '')) ?? 0,
          tenure: selectedTenure!,
        ),
      ),
    );
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
