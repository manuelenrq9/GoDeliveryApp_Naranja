import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shadowColor: Colors.grey, // Agrega esta línea para la sombra gris
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16), // Añadir efecto ripple

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => _showLargeImage(context, data.imageUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: data.imageUrl,
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
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.presentation,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 175, 91, 7)),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onDecrease,
                        icon:
                            const Icon(Icons.remove, color: Color(0xFFFF7000)),
                      ),
                      Text(
                        data.quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
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
      ),
    );
  }
}
