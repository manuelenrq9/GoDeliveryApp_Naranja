import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/combo/presentation/pages/detallecombo.dart';
// Asegúrate de tener este archivo

class ComboItemCatalogo extends StatelessWidget {
  final Combo combo;

  const ComboItemCatalogo({super.key, required this.combo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Cuando se toque el producto, navegamos a la pantalla de detalles del producto
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ComboDetailScreen(combo: combo)),
        );
      },
      child: Card(
        color: Color.fromARGB(255, 255, 253, 253),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: Image.network(
                        combo.comboImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ).image,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Nombre del producto
                Text(
                  combo.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Peso del producto
                /*Text(
                  '${product.weight} gr',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 110, 110, 110)),
                ),
                const SizedBox(height: 8),*/
                // Precio del producto
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      combo.currency,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 245, 121, 20)),
                    ),
                    Text(
                      combo.specialPrice.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
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
