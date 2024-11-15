import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/entities/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 80,
        height: 97,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFFF7000),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 49,
              height: 49,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9),
                child: Image.network(
                  category.image, // Usamos la URL de la categoría
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              category.name, // Usamos el nombre de la categoría
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
