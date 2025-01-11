import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';

class ProductsRepository  {

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

  Future<List<Product>> loadProducts() async {
    futureProducts = _productService.loadData();
    return futureProducts;
  }
}