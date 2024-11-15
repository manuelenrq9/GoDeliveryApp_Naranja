import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';

class ProductCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String precio;
  final String imagen;

  const ProductCard({
    Key? key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imagen),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              nombre,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              descripcion,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  precio,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9027),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_shopping_cart,
                      color: Color.fromARGB(255, 175, 91, 7)),
                  onPressed: () {
                    showLoadingScreen(context, destination: CartScreen());
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
