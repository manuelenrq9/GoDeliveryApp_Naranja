import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/product_detail.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  void _onAddPressed(BuildContext context) {
    // Mostrar un SnackBar indicando que el producto se agregó al carrito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Añadir carrito en futuras actualizaciones :c'),
        duration: Duration(seconds: 2), 
        backgroundColor: Colors.green,// Duración del mensaje
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        showLoadingScreen(context,
            destination: ProductDetailScreen(product: product));

      },
      child: Card(
        color: Color.fromARGB(230, 228, 227, 227),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 60,
                  height: 60,
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                      color: Colors.orange,
                    )),
                    errorWidget: (context, url, error) =>

                        const Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    product.weight.toString() + " gr",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110)),
                  ),
                ],
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(product.currency,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 110, 110, 110))),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        product.price.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  GestureDetector(
                    onTap:() => _onAddPressed(context),  // Acción personalizada para el icono "add"
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFFFF7000),
                    ),

                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
