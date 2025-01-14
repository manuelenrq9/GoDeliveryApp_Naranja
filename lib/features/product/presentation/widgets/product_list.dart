import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/error/failures.dart';
import 'package:godeliveryapp_naranja/features/product/data/repositories/products_repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/domain/usecases/get_product_list.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/widgets/product_card.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  
  late final ProductsRepository repo = ProductsRepository();
  late final GetProductListUseCase useCase = GetProductListUseCase(repo);
  late Future<dartz.Either<Failure,List<Product>>> futureProducts;
  
  void loadProducts() async {
    futureProducts = useCase.execute();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }
  
@override
Widget build(BuildContext context) {
  return FutureBuilder<dartz.Either<Failure, List<Product>>>(
    future: futureProducts,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final dartz.Either<Failure, List<Product>> result = snapshot.data!;

        return result.fold(
          (failure) => Text('Error: $failure'), // Handle failure
          (products) => Wrap(
            children: products.map((product) => ProductItem(product: product)).toList(),
          ), // Handle success
        );
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      return const Center(child: CircularProgressIndicator(color: Colors.orange,));
    },
  );
}


}