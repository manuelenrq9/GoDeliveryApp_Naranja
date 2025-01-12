import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_menu.dart';
import 'package:godeliveryapp_naranja/features/discount/discount_price_menu.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
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
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors
                .white, // Fondo blanco para la tarjeta en modo claro y gris en modo oscuro
        elevation: 5, // Elevación moderada para más profundidad
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordes más redondeados
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16), // Añadir efecto ripple
          onTap: () {
            showLoadingScreen(context,
                destination: ProductDetailScreen(product: product));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto, centrada
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12), // Bordes redondeados
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12), // Bordes redondeados
                      child: CachedNetworkImage(
                        imageUrl: product.image[0],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                          color: Colors.orange,
                        )),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Información del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre del producto
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Peso del producto
                      Text(
                        "${product.weight} gr",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 175, 91, 7),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Precio y botón para añadir al carrito
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DiscountPriceMenu(
                              specialPrice: product.price,
                              discountId: product.discount,
                              currency: product.currency),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ButtonAddCartMenu(product: product),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
