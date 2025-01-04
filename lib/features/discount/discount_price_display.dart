import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
import 'package:godeliveryapp_naranja/core/dataID.services.dart';
import 'package:godeliveryapp_naranja/features/discount/domain/discount.dart';
import 'discount_logic.dart'; // Importamos la lógica de descuento

class DiscountPriceDisplay extends StatelessWidget {
  final num specialPrice;
  final String? discountId;
  final String currency;

  const DiscountPriceDisplay(
      {super.key,
      required this.specialPrice,
      required this.discountId,
      required this.currency});

  @override
  Widget build(BuildContext context) {
    final converter = CurrencyConverter();
    
    // Usamos FutureBuilder para manejar la obtención del descuento asíncrona
    return FutureBuilder<Discount>(
      future: fetchEntityById<Discount>(
        discountId ?? '', // Si el ID es null, se pasa una cadena vacía
        'discount',       // Endpoint específico para descuentos
        (json) => Discount.fromJson(json),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        num priceInUSD = specialPrice;
        num? discountedPrice = specialPrice;

        if (snapshot.hasData) {
          final discount = snapshot.data!;
          discountedPrice = getDiscountedPrice(specialPrice, discount);
        }

        return _buildPriceDisplay(
          converter.convert(priceInUSD.toDouble()), // Convertir precios
          discountedPrice != null ? converter.convert(discountedPrice.toDouble()) : null,
          converter.selectedCurrency,
        );
      },
      // builder: (context, snapshot) {
      //   // Si está esperando la respuesta del Future
      //   if (snapshot.connectionState == ConnectionState.waiting) {
      //     return const Center(
      //         child: CircularProgressIndicator(color: Colors.orange));
      //   }

      //   // Si hubo un error o no se obtuvo un descuento válido
      //   if (snapshot.hasError || !snapshot.hasData) {
      //     return _buildPriceDisplay(specialPrice, null);
      //   }

      //   // Si hay datos, verificamos el descuento y calculamos el precio
      //   Discount discount = snapshot.data!;

      //   // Validamos si el descuento es válido
      //   num discountedPrice = getDiscountedPrice(specialPrice, discount);

      //   // Mostrar el precio original y el precio con descuento
      //   return _buildPriceDisplay(specialPrice, discountedPrice);
      // },
    );
  }

  // Método que construye la visualización del precio, manteniendo el estilo consistente
  Widget _buildPriceDisplay(num originalPrice, num? discountedPrice, String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Precio',
          style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 175, 91, 7),
              fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Si el descuento es válido, mostramos el precio original tachado
            if (discountedPrice != null && discountedPrice != originalPrice)
              Text(
                '${currency} ${originalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough),
              ),
            // Mostrar el precio con descuento o el precio original si no hay descuento
            Text(
              '${currency} ${(discountedPrice ?? originalPrice).toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xFFFF9027),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
