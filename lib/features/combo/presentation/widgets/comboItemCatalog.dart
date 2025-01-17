import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_menu.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/combo/presentation/pages/detallecombo.dart';
import 'package:godeliveryapp_naranja/features/discount/discount_price_menu.dart';

class ComboItemCatalogo extends StatefulWidget {
  final Combo combo;

  const ComboItemCatalogo({super.key, required this.combo});

  @override
  _ComboItemCatalogoState createState() => _ComboItemCatalogoState();
}

class _ComboItemCatalogoState extends State<ComboItemCatalogo> {
  // bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final converter = CurrencyConverter();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ComboDetailScreen(combo: widget.combo)),
        );
      },
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 37, 37, 37)
            : const Color.fromARGB(255, 255, 253, 253),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: Image.network(
                          widget.combo.comboImage[0],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ).image,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.combo.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: DiscountPriceMenu(
                      specialPrice: widget.combo.specialPrice,
                      discountId: widget.combo.discount,
                      currency: widget.combo.currency,
                    ),
                  ),
                ],
              ),
              // Botón flotante
              Positioned(
                bottom: 5,
                right: 0,
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(50),
                  child: ButtonAddCartMenu(
                    combo: widget.combo,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
