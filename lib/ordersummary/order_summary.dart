import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final List<Map<String, String>> summaryData = [
    {'label': 'Subtotal', 'value': '\$ 39.00'},
    {'label': 'Tarifa de entrega', 'value': '\$ 60'},
    {'label': 'Descuento', 'value': '-\$ 1.40'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...summaryData.map(
          (data) => SummaryRow(
            label: data['label']!,
            value: data['value']!,
          ),
        ),
        const Divider(thickness: 1),
        SummaryRow(label: 'Total', value: '\$ 97.60', isTotal: true),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
