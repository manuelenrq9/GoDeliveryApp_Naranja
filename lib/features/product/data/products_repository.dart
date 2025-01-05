import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';

class ProductsRepository  {

  late final DataService<Product> _productService;

  createService(){
    _productService = DataService<Product>(
      endpoint: '/product',
      repository: GenericRepository<Product>(
        storageKey: 'products',
        fromJson: (json) => Product.fromJson(json),
        toJson: (product) => product.toJson(),
      ),
      fromJson: (json) => Product.fromJson(json),
    );
  }

  fetch(){
    createService();
    return _productService.loadData();
  }
}