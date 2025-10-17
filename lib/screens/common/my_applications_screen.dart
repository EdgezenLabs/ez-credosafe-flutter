import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/loans_provider.dart';
import '../../models/application.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});
  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = Provider.of<LoansProvider>(context, listen: false);
      p.loadMyApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<LoansProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.myApplications.isEmpty
              ? const Center(child: Text('No applications yet'))
              : ListView.builder(
                  itemCount: p.myApplications.length,
                  itemBuilder: (context, i) {
                    final ApplicationModel app = p.myApplications[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        title: Text('₹${app.amount.toStringAsFixed(2)}'),
                        subtitle: Text('${app.status} • ${app.createdAt}'),
                        onTap: () {
                          // Optionally navigate to details
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
