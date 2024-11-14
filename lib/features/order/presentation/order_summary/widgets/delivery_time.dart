import 'package:flutter/material.dart';

class DeliveryTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Icons.access_time, color: Color(0xFFFF7000)),
            SizedBox(width: 8),
            Text('Entrega a las 3:00 pm'),
          ],
        ),
        TextButton(
          onPressed: () {
            // Logic to change delivery time
          },
          child: const Text(
            'cambiar la hora',
            style: TextStyle(color: Color.fromARGB(255, 204, 92, 6)),
          ),
        ),
      ],
    );
  }
}
