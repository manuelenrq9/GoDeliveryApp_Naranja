import 'dart:async';
import 'package:godeliveryapp_naranja/features/product/data/products_repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';

class GetProductListUseCase {
  
  late Future<List<Product>> futureProducts;
  late final ProductsRepository repository = ProductsRepository();

  Future<List<Product>> execute() async{
    futureProducts =  repository.loadProducts();
    return futureProducts;
  }
}