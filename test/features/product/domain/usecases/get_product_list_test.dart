import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:godeliveryapp_naranja/features/product/data/repositories/products_repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/domain/usecases/get_product_list.dart';
import 'package:mockito/mockito.dart';

class MockProductsRepository extends Mock implements ProductsRepository{
}

void main(){
  late MockProductsRepository mockProductsRepository;
  late GetProductListUseCase usecase; 

  setUp(() {
    mockProductsRepository = MockProductsRepository();
    usecase = GetProductListUseCase(mockProductsRepository);
  });   

  final tProduct1 = Product(
    id: "f67c26ca-a47a-4bbc-9fb9-9f405ccfc068", 
    name: "coca-cola 2 litros", 
    description: "Destapa la felicidad, coca-cola", 
    image: ["https://res.cloudinary.com/dzlemrxcs/image/upload/gfd8xli6epk8dwhhkvbn?_a=BAMCkGfi0",
    "https://res.cloudinary.com/dzlemrxcs/image/upload/fkgsvzhlogjnc0ws9en5?_a=BAMCkGfi0"], 
    price: 15, 
    currency: "USD", 
    weight: 2, 
    stock: 55, 
    category: ["849c4796-0f3a-4ed8-95f3-629cdbc551f2"], 
    measurement: "kg"
  );

  final tProduct2 = Product(
    id: "919412d0-d65f-4256-8e77-45e528b04331", 
    name: "Té Lipton durazno", 
    description: "Bebia refrezcante con sabor a durazno", 
    image: ["https://res.cloudinary.com/dzlemrxddf/image/upload/gfd9fli7epk8dwzzkvbn?_a=BAMCkGfi0",
    "https://res.cloudinary.com/dzlemrxcs/image/upload/fkgsvzhlogjnc0ws9en5?_a=BAMCkGfi0"], 
    price: 9, 
    currency: "USD", 
    weight: 1, 
    stock: 100, 
    category: ["779c4886-0f3a-5ed9-95f3-629cdbc551f2"], 
    measurement: "kg"
  );

  final tProduct3 = Product(
    id: "919412d0-d65f-4256-8e77-45e528b04331", 
    name: "caramelos life-savers", 
    description: "deliciosos caramelos con sabor a frutas", 
    image: ["https://res.cloudinary.com/dzlemrxddf/image/upload/gfd9fli7epk8dwzzkvbn?_a=BAMCkGfi0",
    "https://res.cloudinary.com/dzlemytos/image/upload/fkgsvzhlogjnc0ws9en5?_a=BAMCkGfi0"], 
    price: 4, 
    currency: "USD", 
    weight: 1, 
    stock: 65, 
    category: ["779c4886-0f3a-5ed9-95f3-629cdbc551h1"], 
    measurement: "kg"
  );

  final tProducts = [tProduct1,tProduct2,tProduct3];

  test(
    'Should get Products from the products repository',
    () async {
      //arrange
      when(mockProductsRepository.loadProducts())
      .thenAnswer((_) async => Future.value(Right(tProducts))); 
      //act
      final result = await usecase.execute();
      //assert
      expect(result, Right(tProducts));
      verify(mockProductsRepository.loadProducts());
      verifyNoMoreInteractions(mockProductsRepository);
    },
  );
}