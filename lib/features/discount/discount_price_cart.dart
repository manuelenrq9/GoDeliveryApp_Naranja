import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/discount/data/discount_fetchID.dart';
import 'package:godeliveryapp_naranja/features/discount/domain/discount.dart';
import 'discount_logic.dart';

class DiscountPriceCart extends StatelessWidget {
  final num originalPrice;
  final num quantity;
  final String currency;
  final String? discountId;

  const DiscountPriceCart({
    super.key,
    required this.originalPrice,
    required this.quantity,
    required this.currency,
    this.discountId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Discount>(
      future: fetchDiscountById(discountId), // Obtenemos el descuento por ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _buildPriceDisplay(originalPrice, quantity, null, currency);
        }

        Discount discount = snapshot.data!;
        num discountedPrice = getDiscountedPrice(originalPrice, discount);

        return _buildPriceDisplay(originalPrice, quantity, discountedPrice, currency);
      },
    );
  }

  // Método que construye la visualización del precio, manteniendo el estilo consistente
  Widget _buildPriceDisplay(num originalPrice, num quantity, num? discountedPrice, String currency) {
    num totalPrice = originalPrice * quantity;
    num? discountedTotalPrice = discountedPrice != null ? discountedPrice * quantity : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Si hay descuento, mostramos el precio original tachado
        if (discountedTotalPrice != null && discountedTotalPrice != totalPrice)
          Text(
            '$currency ${(totalPrice).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        // Mostrar el precio con descuento o el precio original si no hay descuento
        Text(
          '$currency ${(discountedTotalPrice ?? totalPrice).toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFFFF9027),
          ),
        ),
      ],
    );
  }
}
