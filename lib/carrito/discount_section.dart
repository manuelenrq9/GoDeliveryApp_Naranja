import 'package:flutter/material.dart';

class DiscountSection extends StatelessWidget {
  const DiscountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.confirmation_number,
            color: Color(0xFFFF7000),
          ),
          const SizedBox(
              width: 8), // Añadir un espacio entre el icono y el texto
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Aplicar Código de Descuento'),
                    content: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Introduce tu código de descuento',
                      ),
                      onSubmitted: (String code) {
                        // Lógica para aplicar el código de descuento
                        Navigator.of(context).pop();
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Color(0xFFFF7000)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Aplicar',
                          style: TextStyle(color: Color(0xFFFF7000)),
                        ),
                        onPressed: () {
                          // Lógica para aplicar el código de descuento
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              'Aplicar Código de Descuento',
              style: TextStyle(color: Color(0xFFFF7000)),
            ),
          ),
        ],
      ),
    );
  }
}
