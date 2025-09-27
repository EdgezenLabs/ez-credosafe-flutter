import 'package:flutter/material.dart';
import '../models/loan_product.dart';

class LoanCard extends StatelessWidget {
  final LoanProduct product;
  final VoidCallback onApply;
  const LoanCard({required this.product, required this.onApply, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(product.description),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Interest: ${product.interest.toStringAsFixed(2)}%'),
            ElevatedButton(onPressed: onApply, child: const Text('Apply'))
          ])
        ]),
      ),
    );
  }
}
