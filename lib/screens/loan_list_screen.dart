import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loans_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/loan_card.dart';
import 'loan_apply_screen.dart';
import 'my_applications_screen.dart';

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});
  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = Provider.of<LoansProvider>(context, listen: false);
      p.loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loans = Provider.of<LoansProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Products'), actions: [
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyApplicationsScreen())),
          tooltip: 'My Applications',
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await auth.logout();
            Navigator.pushReplacementNamed(context, '/');
          },
        )
      ]),
      body: loans.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => loans.loadProducts(),
              child: ListView.builder(
                itemCount: loans.products.length,
                itemBuilder: (context, i) {
                  final p = loans.products[i];
                  return LoanCard(
                    product: p,
                    onApply: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoanApplyScreen(product: p))),
                  );
                },
              ),
            ),
    );
  }
}
