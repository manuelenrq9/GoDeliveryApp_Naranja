import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/product_detail.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key, 
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          showLoadingScreen(context, destination: const ProductDetailScreen());
        },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.network(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.description,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.weight.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.price.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    product.currency,
                    style: const TextStyle(
                      color: Color(0xFFFF7000),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            const SizedBox(width: 16),
            const Icon(
              Icons.add,
              color: Color(0xFFFF7000),
            ),
            ]
            ),
        ),
      ),
    );
  }
}
