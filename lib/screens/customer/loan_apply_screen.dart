import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/loan_product.dart';
import '../../providers/loans_provider.dart';
import '../../widgets/index.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('Apply - ${widget.product.name}')),
      body: SingleChildScrollView(
        child: FormContainer(
          children: [
            CustomTextField(
              label: 'Company Name',
              hintText: 'Enter company name',
              controller: _company,
            ),
            CustomTextField(
              label: 'Loan Amount',
              hintText: 'Enter loan amount',
              controller: _amount,
              keyboardType: TextInputType.number,
            ),
            CustomTextField(
              label: 'Tenure (months)',
              hintText: 'Enter tenure in months',
              controller: _tenure,
              keyboardType: TextInputType.number,
            ),
            DocumentPicker(onFilesPicked: (files) => setState(() => _files = files)),
            PrimaryButton(
              text: 'Submit Application',
              onPressed: _handleSubmit,
              isLoading: _submitting,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_company.text.isEmpty || _amount.text.isEmpty) {
      return;
    }
    
    setState(() => _submitting = true);
    
    try {
      final loans = Provider.of<LoansProvider>(context, listen: false);
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
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        // Submit failed - handle silently or log for debugging
      }
    } catch (e) {
      // Submit error - handle silently or log for debugging
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }
}
