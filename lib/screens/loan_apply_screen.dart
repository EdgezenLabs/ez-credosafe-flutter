import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/loan_product.dart';
import '../providers/loans_provider.dart';
import '../widgets/document_picker.dart';

class LoanApplyScreen extends StatefulWidget {
  final LoanProduct product;
  const LoanApplyScreen({required this.product, super.key});

  @override
  State<LoanApplyScreen> createState() => _LoanApplyScreenState();
}

class _LoanApplyScreenState extends State<LoanApplyScreen> {
  final _company = TextEditingController();
  final _amount = TextEditingController();
  final _tenure = TextEditingController();
  List<File> _files = [];
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final loans = Provider.of<LoansProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Apply - ${widget.product.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _company, decoration: const InputDecoration(labelText: 'Company Name')),
          const SizedBox(height: 12),
          TextField(controller: _amount, decoration: const InputDecoration(labelText: 'Loan Amount'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: _tenure, decoration: const InputDecoration(labelText: 'Tenure (months)'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          DocumentPicker(onFilesPicked: (files) => setState(() => _files = files)),
          const SizedBox(height: 16),
          _submitting ? const CircularProgressIndicator() : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_company.text.isEmpty || _amount.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields')));
                  return;
                }
                setState(() => _submitting = true);
                try {
                  final form = {
                    'company_name': _company.text.trim(),
                    'amount': double.tryParse(_amount.text) ?? 0,
                    'tenure': int.tryParse(_tenure.text) ?? 0,
                    'product_id': widget.product.id,
                  };
                  final res = await loans.applyLoan(form, _files, (sent, total) {
                    // optional: update progress
                  });
                  if (res['success'] == true || res['status'] == 'ok') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application submitted')));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submit failed: ${res['message'] ?? 'unknown'}')));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submit error: $e')));
                } finally {
                  setState(() => _submitting = false);
                }
              },
              child: const Text('Submit'),
            ),
          )
        ]),
      ),
    );
  }
}
