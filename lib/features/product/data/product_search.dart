import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/widgets/product_card.dart';

class ProductListSearch extends StatefulWidget {
  final String searchText;

  const ProductListSearch({super.key, required this.searchText});
  

  @override
  State<ProductListSearch> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListSearch> {
  late Future<List<Product>> futureProducts;
  late final DataService<Product> _productService;
  // late final DataService<Product> _productService = DataService<Product>(
  //     endpoint: '/product',
  //     repository: GenericRepository<Product>(
  //       storageKey: 'products',
  //       fromJson: (json) => Product.fromJson(json),
  //       toJson: (product) => product.toJson(),
  //     ),
  //     fromJson: (json) => Product.fromJson(json),
  //   );
  

  @override
  void initState() {
    super.initState();
    print("SEARCH NOMBRE");
    print(widget.searchText);
    _productService = DataService<Product>(
      endpoint:
          '/product?name=${widget.searchText}', // Agregar el searchText al endpoint
      repository: GenericRepository<Product>(
        storageKey: 'products',
        fromJson: (json) => Product.fromJson(json),
        toJson: (product) => product.toJson(),
      ),
      fromJson: (json) => Product.fromJson(json),
    );
    loadProducts();
  }

  void loadProducts() async {
    futureProducts = _productService.loadData();
    print("LISTA SEARCH");
    print(futureProducts);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              children: snapshot.data!
                  .map((product) => ProductItem(product: product))
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.orange,
          ));
        });
  }

}

