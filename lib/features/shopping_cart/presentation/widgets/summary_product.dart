import 'package:flutter/material.dart';
import 'summary_row.dart';

class ProductSummary extends StatelessWidget {
  final double totalAmount;

  const ProductSummary({
    super.key,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryRow(
              label: 'Monto', amount: '\$${totalAmount.toStringAsFixed(2)}'),
          const Divider(),
        ],
      ),
    );
  }
}
