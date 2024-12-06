import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_menu.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/product_detail.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showLoadingScreen(context,
            destination: ProductDetailScreen(product: product));
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
        children: [
        Padding(
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
                child: Container(
                height: 50, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // Alineamos el contenido arriba
                  crossAxisAlignment: CrossAxisAlignment.end, // Alineamos el precio a la derecha
                  children: [
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
                        product.price.toStringAsFixed(2),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  
                ]
               ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
              bottom: 15, // Puedes ajustar la distancia desde la parte inferior
              right: 20, // Ajusta la distancia desde el lado derecho
              child: ButtonAddCartMenu(product: product),
            ),
        ]
        ),
      ),
    );
  }
}
