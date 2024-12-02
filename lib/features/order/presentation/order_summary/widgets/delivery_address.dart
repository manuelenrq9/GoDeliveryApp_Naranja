import 'package:flutter/material.dart';

class DeliveryAddress extends StatelessWidget {
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
          // Dirección de entrega con icono y texto
          Flexible(
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFFFF7000),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Luminous tower, Flat E2, Sheikh ghat, Sylhet',
                    overflow: TextOverflow.ellipsis,
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
          // Botón de editar
          IconButton(
            onPressed: () {
              // Lógica para cambiar la dirección
            },
            icon: const Icon(Icons.edit, color: Color(0xFFCD5B06)),
          ),
        ],
      ),
    );
  }
}
