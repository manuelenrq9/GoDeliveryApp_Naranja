import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_menu.dart';
import 'package:godeliveryapp_naranja/features/discount/discount_price_menu.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
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
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 37, 37, 37)
            : const Color.fromARGB(255, 255, 253, 253),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del producto
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.product.image[0],
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
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
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
                  const Spacer(),
                  // Precio al final
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: DiscountPriceMenu(
                      specialPrice: widget.product.price,
                      discountId: widget.product.discount,
                      currency: widget.product.currency,
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
                    product: widget.product,
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
