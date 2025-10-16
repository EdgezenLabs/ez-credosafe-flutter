import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/loan_status.dart';
import '../providers/loan_status_provider.dart';
import '../providers/auth_provider.dart';
import 'personal_loan_application_screen.dart';
import '../widgets/common/gradient_button.dart';

class LoanTypeSelectionScreen extends StatefulWidget {
  const LoanTypeSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LoanTypeSelectionScreen> createState() => _LoanTypeSelectionScreenState();
}

class _LoanTypeSelectionScreenState extends State<LoanTypeSelectionScreen> {
  LoanType? selectedLoanType;

  @override
  void initState() {
    super.initState();
    // Fetch loan status to get available loan types
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      context.read<LoanStatusProvider>().fetchLoanStatus(authProvider);
    });
  }

  @override
  void dispose() {
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
              Color(0xFFDAB360), // #DAB360 at 0%
              Color(0xFF906C2A), // #906C2A at 83.17%  
              Color(0xFF8C6829), // #8C6829 at 100%
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
                        'Error loading loan types',
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
                        isCompact: true,
                      ),
                    ],
                  ),
                );
              }

              final loanTypes = loanProvider.loanStatus?.loanTypes;
              
              // Fallback loan types if API doesn't provide them
              final List<LoanType> displayLoanTypes = (loanTypes != null && loanTypes.isNotEmpty) 
                ? loanTypes 
                : [
                    LoanType(
                      id: '1',
                      name: 'Personal Loan',
                      description: 'Get funds for personal needs with flexible repayment options',
                      minAmount: 10000,
                      maxAmount: 500000,
                      interestRate: 10.5,
                      maxTenure: 60,
                      eligibilityCriteria: ['Age: 21-65 years', 'Minimum salary: ₹15,000/month'],
                      requiredDocuments: ['Aadhaar Card', 'PAN Card', 'Salary Slips'],
                    ),
                    LoanType(
                      id: '2',
                      name: 'Home Loan',
                      description: 'Fulfill your dream of owning a home with competitive rates',
                      minAmount: 500000,
                      maxAmount: 10000000,
                      interestRate: 8.5,
                      maxTenure: 240,
                      eligibilityCriteria: ['Age: 21-65 years', 'Minimum salary: ₹25,000/month'],
                      requiredDocuments: ['Aadhaar Card', 'PAN Card', 'Property Documents'],
                    ),
                    LoanType(
                      id: '3',
                      name: 'Business Loan',
                      description: 'Grow your business with our business financing solutions',
                      minAmount: 50000,
                      maxAmount: 5000000,
                      interestRate: 12.0,
                      maxTenure: 84,
                      eligibilityCriteria: ['Business vintage: 2+ years', 'Good credit score'],
                      requiredDocuments: ['Aadhaar Card', 'PAN Card', 'Business Registration'],
                    ),
                  ];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with user info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
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
                        // Sign Out Button
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            tooltip: 'Sign Out',
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // White Container with Loan Type Cards
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF300700),
                                ),
                                children: [
                                  TextSpan(text: 'Please choose '),
                                  TextSpan(
                                    text: 'your loan type',
                                    style: TextStyle(
                                      color: Color(0xFFDAB360),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Loan Type Cards
                            ...displayLoanTypes.map((loanType) => _buildLoanTypeCard(loanType)),
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
    );
  }

  Widget _buildLoanTypeCard(LoanType loanType) {
    final isSelected = selectedLoanType?.id == loanType.id;
    
    // Split the loan name to style first word golden, rest dark
    List<String> nameParts = loanType.name.toUpperCase().split(' ');
    String firstPart = nameParts.isNotEmpty ? nameParts[0] : '';
    String secondPart = nameParts.length > 1 ? ' ${nameParts.sublist(1).join(' ')}' : '';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedLoanType = loanType;
            });
            
            // Navigate to the loan application screen based on loan type
            // For now, all loan types navigate to PersonalLoanApplicationScreen
            // You can add more screens for different loan types later
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalLoanApplicationScreen(
                  loanType: loanType.name,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 70, // Fixed height for all cards
            decoration: BoxDecoration(
              gradient: isSelected 
                ? const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFDAB360), // #DAB360 at 0%
                      Color(0xFF906C2A), // #906C2A at 83.17%  
                      Color(0xFF8C6829), // #8C6829 at 100%
                    ],
                    stops: [0.0, 0.8317, 1.0],
                  ) 
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF), // #FFFFFF at 0%
                      Color(0xFFE8E8E8), // #E8E8E8 at 100%
                    ],
                    stops: [0.0, 1.0],
                  ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Gradient border using Container
                if (!isSelected)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        width: 0, // We'll use the gradient border below
                        color: Colors.transparent,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFC7A052), // #C7A052 at 0%
                            Color(0xFF614E28), // #614E28 at 100%
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                // Inner container with padding to create border effect
                Container(
                  margin: isSelected ? EdgeInsets.zero : const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    gradient: isSelected 
                      ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFDAB360), // #DAB360 at 0%
                            Color(0xFF906C2A), // #906C2A at 83.17%  
                            Color(0xFF8C6829), // #8C6829 at 100%
                          ],
                          stops: [0.0, 0.8317, 1.0],
                        ) 
                      : const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFFFFF), // #FFFFFF at 0%
                            Color(0xFFE8E8E8), // #E8E8E8 at 100%
                          ],
                          stops: [0.0, 1.0],
                        ),
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Center(
                    child: isSelected 
                      ? Text(
                          firstPart + secondPart,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: firstPart,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFDAB360),
                                ),
                              ),
                              TextSpan(
                                text: secondPart,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF300700),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}