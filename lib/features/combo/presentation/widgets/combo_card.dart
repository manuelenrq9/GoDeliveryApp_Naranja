import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_menu.dart';
import 'package:godeliveryapp_naranja/features/combo/presentation/pages/detallecombo.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/discount/discount_price_menu.dart';

class ComboCard extends StatelessWidget {
  final Combo combo;

  const ComboCard({super.key, required this.combo});

  @override
  Widget build(BuildContext context) {
    // Obtener ancho y alto de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calcular ancho y altura de la tarjeta en función del tamaño de la pantalla
    double cardWidth =
        screenWidth * 0.44; // Por ejemplo, el 45% del ancho de la pantalla
    double imageHeight =
        screenHeight * 0.14; // 15% de la altura de la pantalla para la imagen

    return Padding(
      padding: const EdgeInsets.all(
          8.0), // Espaciado externo para evitar corte de bordes
      child: GestureDetector(
        onTap: () {
          showLoadingScreen(context,
              destination: ComboDetailScreen(combo: combo));
        },
        child: Container(
          width: cardWidth, // Ancho dinámico de la tarjeta
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 37, 37, 37)
                : Colors.white,
            borderRadius: BorderRadius.circular(12), // Borde redondeado
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(
                    0, 3), // Sombra para mejorar visibilidad de bordes
              ),
            ],
          ),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(6.0), // Espaciado interno reducido
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del combo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10), // Borde redondeado para la imagen
                    child: CachedNetworkImage(
                      imageUrl: combo.comboImage[0],
                      width: double.infinity,
                      height: imageHeight, // Altura dinámica de la imagen
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                        color: Colors.orange,
                      )),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Título del combo
                  Text(
                    combo.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Descripción del combo con ajuste flexible
                  Text(
                    combo.description, // Manejo de null en descripción
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 175, 91, 7),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Precio y botón en extremos
                  DiscountPriceMenu(
                      specialPrice: combo.specialPrice,
                      discountId: combo.discount,
                      currency: combo.currency),
                ],
              ),
            ),
            Positioned(
              bottom: 10, // Ajusta la distancia desde la parte inferior
              right: 10, // Ajusta la distancia desde el lado derecho
              child: Material(
                elevation: 5.0, // Efecto de elevación
                borderRadius: BorderRadius.circular(50), // Borde redondeado
                child: ButtonAddCartMenu(
                    combo: combo), // Usamos el botón flotante para el combo
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
