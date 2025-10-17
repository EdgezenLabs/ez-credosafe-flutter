import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../models/admin_loan_application.dart';

class AdminLoanApplicationsScreen extends StatefulWidget {
  const AdminLoanApplicationsScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoanApplicationsScreen> createState() => _AdminLoanApplicationsScreenState();
}

class _AdminLoanApplicationsScreenState extends State<AdminLoanApplicationsScreen> {
  late Future<List<AdminLoanApplication>> _applicationsFuture;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
  _applicationsFuture = ApiService.getAdminLoanApplications(auth.token ?? '');
  }

  Future<void> _approveApplication(String applicationId) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await ApiService.approveLoanApplication(applicationId, token: auth.token);
    setState(() {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      _applicationsFuture = ApiService.getAdminLoanApplications(auth.token ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Loan Applications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF300700),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.goldenGradient,
        ),
        child: FutureBuilder<List<AdminLoanApplication>>(
          future: _applicationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final applications = snapshot.data ?? [];
            if (applications.isEmpty) {
              return const Center(child: Text('No applications found'));
            }
            return ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final app = applications[index];
                // card
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            app.userName ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF300700),
                            ),
                          ),
                          // status pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _statusColor(app.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _statusLabel(app.status),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Loan Type: ${app.loanType ?? ''}'),
                      const SizedBox(height: 4),
                      Text('Requested Amount: ₹${app.requestedAmount?.toStringAsFixed(0) ?? ''}'),
                      const SizedBox(height: 4),
                      Text('Status: ${app.status ?? ''}'),
                      const SizedBox(height: 8),
                      Text('Application ID: ${app.applicationId ?? ''}', style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (app.status == 'under_review' || app.status == 'cancelled')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4AF37),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _approveApplication(app.applicationId ?? ''),
                              child: const Text('Approve'),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'under_review':
        return Colors.orange;
      default:
        return const Color(0xFF300700);
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'approved':
        return 'Approved';
      case 'cancelled':
        return 'Cancelled';
      case 'under_review':
        return 'Under review';
      default:
        return status ?? 'Unknown';
    }
  }
}
