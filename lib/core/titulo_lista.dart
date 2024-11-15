import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';

class TituloLista extends StatefulWidget {
  final String titulo;
  final Widget next;
  const TituloLista({super.key, required this.titulo, required this.next});

  @override
  State<TituloLista> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<TituloLista> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.titulo,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              showLoadingScreen(context, destination: widget.next);
            },
            child: const Text(
              'Ver más',
              style: TextStyle(color: Color(0xFFFF7000)),
            ),
          ),
        ],
      ),
    );
  }
}
