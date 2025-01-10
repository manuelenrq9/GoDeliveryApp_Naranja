import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/domain/usecases/get_product_list.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/widgets/product_card.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  
  late Future<List<Product>> futureProducts;
  late GetProductListUseCase useCase = GetProductListUseCase();
  
  void loadProducts() async {
    futureProducts = useCase.execute();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return Wrap(
        children: snapshot.data!.map((product) => ProductItem(product: product)).toList(),
      );
        } else if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator(color: Colors.orange,));
      }
    );
  }
}