import 'package:flutter_test/flutter_test.dart';
import 'package:godeliveryapp_naranja/features/product/data/repositories/products_repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/domain/usecases/get_product_list.dart';
import 'package:mockito/mockito.dart';

class MockProductsRepository extends Mock implements ProductsRepository{
  
}

void main(){
  GetProductListUseCase usecase;
  MockProductsRepository mockProductsRepository; 
  setUp(() {
    mockProductsRepository = MockProductsRepository();
    usecase = GetProductListUseCase(mockProductsRepository); 
  });

  final tProduct = Product(id: , name: name, description: description, image: image, price: price, currency: currency, weight: weight, stock: stock, category: category, measurement: measurement)

  test(
    'Should get Products from the products repository',
    () async {
      //arrange

      //act

      //assert
    },
  )
}