import 'package:dartz/dartz.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/core/error/failures.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/domain/repositories/Iproducts_repository.dart';

class ProductsRepository implements IProductsRepository{

  late Future<List<Product>> futureProducts;
  
  late final DataService<Product> _productService = DataService<Product>(
      endpoint: '/product/many?perpage=13',
      repository: GenericRepository<Product>(
        storageKey: 'products',
        fromJson: (json) => Product.fromJson(json),
        toJson: (product) => product.toJson(),
      ),
      fromJson: (json) => Product.fromJson(json),
    );

  Future<Either<Failure, List<Product>>> loadProducts() async {
    try {
      final products = await _productService.loadData();
      if (products.isEmpty) {
        return Left(NoProductsReceivedFailure()); // Assuming NoProductsReceivedFailure is defined in your failures package
      } else {
        return Right(products);
      }
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

}