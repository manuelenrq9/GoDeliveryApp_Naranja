import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  late Future<List<Product>> futureProducts;
  
  late final DataService<Product> _productService = DataService<Product>(
      endpoint: '/product/many',
      repository: GenericRepository<Product>(
        storageKey: 'products',
        fromJson: (json) => Product.fromJson(json),
        toJson: (product) => product.toJson(),
      ),
      fromJson: (json) => Product.fromJson(json),
    );

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    futureProducts = _productService.loadData();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          print(snapshot.data);
          return Wrap(
        children: snapshot.data!.map((product) => ProductItem(product: product)).toList(),
      );
        } else if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator(color: Colors.orange,));
      }
    );
  }
}