import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_menu.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/product_detail.dart';

class ProductItemCatalogo extends StatefulWidget {
  final Product product;

  const ProductItemCatalogo({super.key, required this.product});

  @override
  State<ProductItemCatalogo> createState() => _ProductItemCatalogoState();
}

class _ProductItemCatalogoState extends State<ProductItemCatalogo> {
  bool isFavorite = false; // Estado inicial del favorito

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetailScreen(product: widget.product)),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error,
                            size: 50, color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Nombre del producto y botón de favoritos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite; // Cambia el estado
                        });
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? Color(0xFFFF9027)
                            : const Color.fromARGB(255, 194, 192, 192),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Peso del producto
                Text(
                  '${widget.product.weight} gr',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 175, 91, 7),
                  ),
                ),
                const SizedBox(height: 12),
                // Precio y disponibilidad
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.product.currency} ${widget.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9027),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Disponible",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(50),
                        child: ButtonAddCartMenu(
                          product: widget.product,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
