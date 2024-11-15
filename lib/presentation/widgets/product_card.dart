import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/product_detail.dart';
import 'package:godeliveryapp_naranja/repositories/local_storage.repository.dart';
import 'package:http/http.dart' as http;

Future <List<Product>> fetchProducts() async {
  try{
    final response = await http.get(Uri.parse('https://orangeteam-deliverybackend-production.up.railway.app/product'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final Map<String,dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> productsData = jsonData['products'];
      return productsData.map((productJson) => Product.fromJson(productJson)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch products');
    } 
  }catch (e) {
        if (e is SocketException) {
          throw 'No tienes conexión a Internet';
        } else {
          throw Exception('Error al cargar los productos');
        }
      }
  }  



class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
    // Inicializa futureProducts con un valor predeterminado (lista vacía)
  late Future<List<Product>> futureProducts = Future.value([]);

  final _productRepository = GenericRepository<Product>(
    storageKey: 'products', // La clave de almacenamiento para productos
    fromJson: (json) => Product.fromJson(json), // Función de deserialización
    toJson: (product) => product.toJson(), // Función de serialización
  );

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // Método para cargar productos
  void loadProducts() async {
    // Intenta cargar productos del almacenamiento local
    final savedProducts = await _productRepository.loadData();
    if (savedProducts.isNotEmpty) {
      setState(() {
        futureProducts = Future.value(savedProducts);
      });
    } else {
      // Si no hay productos guardados, haz la solicitud HTTP
      futureProducts = fetchProducts();
      futureProducts.then((products) {
        // Guarda los productos recuperados para persistencia
        _productRepository.saveData(products);
      });
      setState(() {});
    }
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
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator(color: Colors.orange,));
      }
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key, 
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          showLoadingScreen(context, destination: const ProductDetailScreen());
        },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CachedNetworkImage(
                  imageUrl: product.image,
                  width: 60,
                  height: 60, // Altura dinámica de la imagen
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.orange,)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.description,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.weight.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.price.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    product.currency,
                    style: const TextStyle(
                      color: Color(0xFFFF7000),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            const SizedBox(width: 16),
            const Icon(
              Icons.add,
              color: Color(0xFFFF7000),
            ),
            ]
            ),
        ),
      ),
    );
  }
}
