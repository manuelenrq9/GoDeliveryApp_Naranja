import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  final String orderNumber;
  final String status;

  const OrderHeader({Key? key, required this.orderNumber, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 36, 36, 36)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4), // Sombra sutil
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Número de orden
          Text(
            'Order #${orderNumber}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white // Color de texto blanco en modo oscuro
                  : Colors.black87, // Color de texto más oscuro en modo claro
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          // Estado de la orden
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size:
                    20, // Aumentamos el tamaño del ícono para mayor visibilidad
              ),
              Text(
                status,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 13, // Tamaño de texto adecuado para la visibilidad
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
