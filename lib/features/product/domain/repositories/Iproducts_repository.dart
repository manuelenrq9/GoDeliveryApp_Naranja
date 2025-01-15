
import 'package:dartz/dartz.dart';
import 'package:godeliveryapp_naranja/core/error/failures.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';

abstract class IProductsRepository{
    Future<Either<Failure,List<Product>>> loadProducts(); 
}