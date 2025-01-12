import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderPayment.dart';

class OrderSummary extends StatelessWidget {
  final Order order;

  const OrderSummary({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<OrderPayment> payment = order.paymentMethod;
    double total = 0;
    String currency = '';
    payment.forEach((payment) {
      total = payment.total;
      currency = payment.currency;
    });

    return Column(
      children: [
        SummaryRow(
            label: 'Subtotal', value: '$currency ${total.toStringAsFixed(2)}'),
        SummaryRow(label: 'Tarifa de entrega', value: '\$60'),
        SummaryRow(label: 'Descuento', value: '-\$67'),
        const Divider(thickness: 1),
        SummaryRow(label: 'Total', value: '\$78'),
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
