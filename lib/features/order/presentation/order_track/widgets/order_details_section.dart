import 'package:flutter/material.dart';

class OrderDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Orden #1334426",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Precio: \$550",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showCancelConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7000),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Cancelar Orden",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Confirmación',
              style: TextStyle(
                color: Color(0xFFFF7000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: const Text(
            '¿Estás seguro de que deseas cancelar esta orden?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el dialog sin hacer nada
              },
              child: const Text(
                'No',
                style: TextStyle(color: Color(0xFFFF7000)),
              ),
            ),
            TextButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para cancelar la orden
                Navigator.of(context).pop(); // Cierra el dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Orden cancelada exitosamente'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text(
                'Sí',
                style: TextStyle(color: Color(0xFFFF7000)),
              ),
            ),
          ],
        );
      },
    );
  }
}
