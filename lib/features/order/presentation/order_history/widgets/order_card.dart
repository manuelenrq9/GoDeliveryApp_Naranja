import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String date;
  final String orderId;
  final int price;
  final String status;
  final List<String> items;
  final String deliveryTime;

  const OrderCard({
    Key? key,
    required this.date,
    required this.orderId,
    required this.price,
    required this.status,
    required this.items,
    required this.deliveryTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$$price',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Order #$orderId',
                style: const TextStyle(color: Color(0xFFFF7000))),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => Text('- $item')).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'Delivered esta $deliveryTime',
              style: TextStyle(
                color: status == 'Delivered' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (status == 'Delivered')
                  Flexible(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Solicitar reembolso'),
                    ),
                  ),
                Flexible(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      status == 'Delivered'
                          ? 'Reordenar '
                          : 'Reportar problema',
                      style: TextStyle(
                        color: status == 'Delivered'
                            ? const Color.fromARGB(255, 207, 94, 7)
                            : const Color.fromARGB(255, 167, 74, 3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
