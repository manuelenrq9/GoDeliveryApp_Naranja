import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/category/domain/category.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/ProductCategory.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Navega a ProductCategoryScreen pasando el nombre de la categoría
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductCategoryScreen(
                categoryId: category.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Container(
            width: 110, // Incrementamos el ancho
            height: 120, // Ajustamos la altura para que todo encaje bien
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 25, 1, 1)
                  : const Color(0xFFFF7000), // Cambiamos el color según el modo
              boxShadow: Theme.of(context).brightness == Brightness.dark
                  ? [
                      BoxShadow(
                        color: const Color.fromARGB(255, 128, 126, 126)
                            .withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 65, // Ajustamos el tamaño del contenedor de la imagen
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Image.network(
                      category.image, // Usamos la URL de la categoría
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Text(
                      category.name, // Usamos el nombre de la categoría
                      maxLines:
                          2, // Permitimos hasta dos líneas para nombres largos
                      overflow: TextOverflow.ellipsis, // Cortamos con "..."
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Hacemos la fuente un poco más grande
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
