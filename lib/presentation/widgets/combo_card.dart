import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/detallecombo.dart';
import 'package:godeliveryapp_naranja/presentation/interfaces/loading_screen.dart';

class ComboCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final double price;

  const ComboCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener ancho y alto de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calcular ancho y altura de la tarjeta en función del tamaño de la pantalla
    double cardWidth = screenWidth * 0.45; // Por ejemplo, el 45% del ancho de la pantalla
    double imageHeight = screenHeight * 0.15; // 15% de la altura de la pantalla para la imagen

    return Padding(
      padding: const EdgeInsets.all(8.0), // Espaciado externo para evitar corte de bordes
      child: GestureDetector(
        onTap: () {
          showLoadingScreen(context,destination: const ComboDetailScreen());
        },
        child: Container(
          width: cardWidth, // Ancho dinámico de la tarjeta
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), // Borde redondeado
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Sombra para mejorar visibilidad de bordes
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0), // Espaciado interno reducido
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del combo
                ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Borde redondeado para la imagen
                  child: Image.network(
                    imagePath,
                    width: double.infinity,
                    height: imageHeight, // Altura dinámica de la imagen
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                // Título del combo
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, 
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Descripción del combo con ajuste flexible
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12, 
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // Precio y botón en extremos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, 
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Acción para agregar al carrito
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7000),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        minimumSize: const Size(30, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 12, color: Colors.white),
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
