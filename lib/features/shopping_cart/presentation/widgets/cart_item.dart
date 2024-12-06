import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/discount/data/discount_fetchID.dart';
import 'package:godeliveryapp_naranja/features/discount/discount_logic.dart';
import 'package:photo_view/photo_view.dart';

import '../../domain/cart_item_data.dart';

class CartItem extends StatefulWidget {
  final CartItemData data;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.data,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  num? discountedPrice;

  @override
  void initState() {
    super.initState();
    _fetchDiscount();
  }

  Future<void> _fetchDiscount() async {
    if (widget.data.discount != null) {
      final discount = await fetchDiscountById(widget.data.discount);
      setState(() {
        discountedPrice = getDiscountedPrice(widget.data.price, discount);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16), // Añadir efecto ripple
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row( // Usamos Row para alinear los elementos horizontalmente
            children: [
              // Imagen y nombre del producto a la izquierda
              GestureDetector(
                onTap: () => _showLargeImage(context, widget.data.imageUrl),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.data.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data.presentation,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 175, 91, 7)),
                    ),
                  ],
                ),
              ),
              // Precio y cantidad a la derecha
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (discountedPrice != null &&
                      discountedPrice != widget.data.price)
                    Text(
                      '${widget.data.currency} ${(widget.data.price * widget.data.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    '${widget.data.currency} ${((discountedPrice ?? widget.data.price) * widget.data.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9027),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min, // Evitar que el Row ocupe todo el espacio
                    children: [
                      IconButton(
                        onPressed: widget.onDecrease,
                        icon: const Icon(Icons.remove, color: Color(0xFFFF7000)),
                      ),
                      Text(
                        widget.data.quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: widget.onIncrease,
                        icon: const Icon(Icons.add, color: Color(0xFFFF7000)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLargeImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFFF9027),
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PhotoView(
                    imageProvider: NetworkImage(imageUrl),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF9027),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
