import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/cart_item_data.dart';

class CartItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CachedNetworkImage(
                    imageUrl: data.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                      color: Colors.orange,
                    )),
                    errorWidget: (context, url, error) =>

                        const Icon(Icons.error),
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data.presentation,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(data.price * data.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrease,
                      icon: const Icon(Icons.remove, color: Color(0xFFFF7000)),
                    ),
                    Text(data.quantity.toString()),
                    IconButton(
                      onPressed: onIncrease,
                      icon: const Icon(Icons.add, color: Color(0xFFFF7000)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
