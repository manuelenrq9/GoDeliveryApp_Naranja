import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_menu.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/product_detail.dart';
import 'dart:math';

class ProductItemCatalogo extends StatefulWidget {
  final Product product;

  const ProductItemCatalogo({super.key, required this.product});

  @override
  State<ProductItemCatalogo> createState() => _ProductItemCatalogoState();
}

class _ProductItemCatalogoState extends State<ProductItemCatalogo> {
  bool isFavorite = false; // Estado inicial del favorito

  // Simulando una calificación (puedes reemplazar este valor con la calificación real)
  double rating = 4.5; // Cambia este valor según la calificación que desees

  // Función para generar calificaciones basadas en el hash del producto
  int getSimulatedRating(Product product) {
    final seed = product.name.hashCode; // Usa el hash del nombre como semilla
    final random = Random(seed); // Generador aleatorio basado en la semilla
    return random.nextInt(6); // Genera un número entre 0 y 5
  }

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
                      width: 75,
                      height: 75,
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
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
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
                const SizedBox(height: 10),
                // Estrellas para calificar
                Row(
                  children: [
                    // Estrellas
                    ...List.generate(5, (index) {
                      if (rating >= index + 1) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        );
                      } else if (rating > index) {
                        return const Icon(
                          Icons.star_half,
                          color: Colors.amber,
                          size: 16,
                        );
                      } else {
                        return const Icon(
                          Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }
                    }),
                    const SizedBox(width: 4),
                    // Calificación numérica
                    Text(
                      "$rating",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
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
