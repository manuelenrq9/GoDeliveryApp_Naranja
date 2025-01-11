import 'package:dartz/dartz.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/core/error/failures.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/domain/repositories/Iproducts_repository.dart';

class ProductsRepository extends IProductsRepository{

  late Future<List<Product>> futureProducts;
  
  late final DataService<Product> _productService = DataService<Product>(
      endpoint: '/product/many?perpage=15',
      repository: GenericRepository<Product>(
        storageKey: 'products',
        fromJson: (json) => Product.fromJson(json),
        toJson: (product) => product.toJson(),
      ),
      fromJson: (json) => Product.fromJson(json),
    );

  Future<Either<Failure,List<Product>>> loadProducts() async {
    futureProducts = _productService.loadData();
    return futureProducts;
  }
}