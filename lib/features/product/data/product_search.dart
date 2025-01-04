import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/widgets/product_card.dart';

class ProductListSearch extends StatelessWidget {
  final String searchText;

  const ProductListSearch({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final productService = DataService<Product>(
      endpoint: '/product?name=$searchText',
      repository: GenericRepository<Product>(
        storageKey: 'products',
        fromJson: (json) => Product.fromJson(json),
        toJson: (product) => product.toJson(),
      ),
      fromJson: (json) => Product.fromJson(json),
    );

    return FutureBuilder<List<Product>>(
      future: productService.loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No se encontraron productos.');
        }

        return Wrap(
          children: snapshot.data!
              .map((product) => ProductItem(product: product))
              .toList(),
        );
      },
    );
  }
}
