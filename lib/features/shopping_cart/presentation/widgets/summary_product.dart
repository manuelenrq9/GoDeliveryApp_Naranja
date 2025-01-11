import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
import 'summary_row.dart';

class ProductSummary extends StatelessWidget {
  final double totalAmount;

  const ProductSummary({
    super.key,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
  final converter = CurrencyConverter();
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(totalAmount!=0)
            SummaryRow(
                label: 'Monto', amount: '${converter.selectedCurrency} ${converter.convert(totalAmount).toStringAsFixed(2)}'),
          if(totalAmount == 0)
            SummaryRow(
                label: 'Tarifa de envío', amount: 'Por calcular...'),
          const Divider(),
        ],
      ),
    );
  }
}
