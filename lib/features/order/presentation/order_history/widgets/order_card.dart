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
    final isDelivered = status == 'Delivered';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fecha y precio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    '\$$price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // ID del pedido
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Order #$orderId',
                    style: const TextStyle(
                      color: Color(0xFFFF7000),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: isDelivered ? Colors.green : Colors.red,
                ),
              ],
            ),
            const Divider(),
            // Lista de items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Items:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: items
                      .map((item) => Chip(
                            label: Text(
                              item,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor:
                                Colors.grey.shade200.withOpacity(0.5),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Tiempo de entrega
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Entrega estimada: $deliveryTime',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            // Botones de acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isDelivered)
                  Flexible(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh, color: Colors.redAccent),
                      label: const Text('Solicitar reembolso'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                    ),
                  ),
                Flexible(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      isDelivered ? Icons.shopping_cart : Icons.error_outline,
                      color: isDelivered
                          ? const Color(0xFFFF7000)
                          : const Color(0xFFB71C1C),
                    ),
                    label: Text(
                      isDelivered ? 'Reordenar' : 'Reportar problema',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDelivered
                          ? const Color(0xFFFF7000)
                          : const Color(0xFFB71C1C),
                      side: isDelivered
                          ? const BorderSide(color: Color(0xFFFF7000))
                          : null,
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
