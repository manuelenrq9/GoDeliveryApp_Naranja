import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
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
      endpoint: '/product/many?page=$_randomNumber',
      repository: GenericRepository<Product>(
        storageKey: 'products',
        fromJson: (json) => Product.fromJson(json),
        toJson: (product) => product.toJson(),
      ),
      fromJson: (json) => Product.fromJson(json),
    );

  int _randomNumber = 1;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    
    generateRandomNumber();
    futureProducts = _productService.loadData();
    setState(() {});
  }

    void generateRandomNumber() {
    final random = Random();
    _randomNumber = random.nextInt(4) + 1; // Genera un número entre 1 y 5
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