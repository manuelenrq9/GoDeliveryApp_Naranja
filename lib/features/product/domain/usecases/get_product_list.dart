import 'dart:async';
import 'package:godeliveryapp_naranja/features/product/data/repositories/products_repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/domain/repositories/Iproducts_repository.dart';

class GetProductListUseCase {
  
  late Future<List<Product>> futureProducts;
  late final IProductsRepository repository = ProductsRepository();

  Future<List<Product>> execute() async{
    futureProducts =  repository.loadProducts();
    return futureProducts;
  }
}