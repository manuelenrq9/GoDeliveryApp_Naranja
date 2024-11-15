import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/widgets/product_card.dart';
import 'package:http/http.dart' as http;


// Función para verificar la conexión a internet
Future<bool> hasInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

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
    try {
      // Intentamos cargar los productos de la API
      final products = await fetchProducts();
      setState(() {
        futureProducts = Future.value(products);
      });

      // Guardamos los productos recuperados para persistencia en caché
      _productRepository.saveData(products);
    } catch (e) {
      // Si no hay conexión o si falla la API, intentamos cargar desde la caché
      if (e == 'No tienes conexión a Internet') {
        final savedProducts = await _productRepository.loadData();
        setState(() {
          futureProducts = Future.value(savedProducts);
        });
      } else {
        // Si ocurre un error inesperado, mostramos el error
        setState(() {
          futureProducts = Future.error('Error al cargar los productos');
        });
      }
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
          return Text('Error: ${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator(color: Colors.orange,));
      }
    );
  }
}