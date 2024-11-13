import 'package:flutter/material.dart';

class DeliveryAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFFFF7000)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Luminous tower, Flat E2, Sheikh ghat, Sylhet',
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            // Logic to change delivery time
          },
          child: const Text(
            'editar',
            style: TextStyle(color: Color.fromARGB(255, 204, 92, 6)),
          ),
        ),
      ],
    );
  }
}
