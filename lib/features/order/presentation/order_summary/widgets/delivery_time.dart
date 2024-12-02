import 'package:flutter/material.dart';

class DeliveryTime extends StatelessWidget {
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
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Indicador de hora de entrega
          Flexible(
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFFFF7000),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Entrega a las 3:00 pm',
                    overflow:
                        TextOverflow.ellipsis, // Texto con puntos suspensivos
                    maxLines: 1, // Limita el texto a una línea
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botón de cambiar hora
          TextButton.icon(
            onPressed: () {
              // Lógica para cambiar la hora de entrega
            },
            icon: const Icon(
              Icons.edit,
              color: Color(0xFFCD5B06),
            ),
            label: const Text(
              'Cambiar hora',
              style: TextStyle(
                color: Color(0xFFCD5B06),
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 30),
            ),
          ),
        ],
      ),
    );
  }
}
