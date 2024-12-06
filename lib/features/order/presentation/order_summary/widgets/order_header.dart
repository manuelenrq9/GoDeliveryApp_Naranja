import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
            'Order #1334426',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Color de texto más oscuro
            ),
          ),
          // Estado de la orden
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size:
                    24, // Aumentamos el tamaño del ícono para mayor visibilidad
              ),
              const SizedBox(width: 8),
              Text(
                'Delivered',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 16, // Tamaño de texto adecuado para la visibilidad
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
