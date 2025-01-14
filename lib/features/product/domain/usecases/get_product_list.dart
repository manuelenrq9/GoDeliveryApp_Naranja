import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:godeliveryapp_naranja/core/error/failures.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/domain/repositories/Iproducts_repository.dart';

class GetProductListUseCase {
  
  //late Future<Either<Failure,List<Product>>> futureProducts;
  late final IProductsRepository repository;

  GetProductListUseCase(this.repository);

  Future<Either<Failure,List<Product>>> execute() async{
    //futureProducts =  repository.loadProducts();
    return repository.loadProducts();
  }
}