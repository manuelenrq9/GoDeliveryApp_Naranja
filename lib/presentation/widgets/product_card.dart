import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/entities/product.dart'; // Asegúrate de tener esta clase
import 'package:godeliveryapp_naranja/presentation/interfaces/loading_screen.dart'; // Asegúrate de que esta función esté importada
import 'package:godeliveryapp_naranja/product_detail.dart';
import 'package:http/http.dart' as http;

// Función para obtener los productos
Future<List<Product>> fetchProducts() async {
  final response = await http.get(
    Uri.parse(
        'https://orangeteam-deliverybackend-production.up.railway.app/product'),
  );

  print(response.body);
  print(response.statusCode);

  if (response.statusCode == 200) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> productsData = jsonData['products'];
      return productsData
          .map((productJson) => Product.fromJson(productJson))
          .toList();
    } catch (e) {
      throw Exception('Error parsing products data: $e');
    }
  } else {
    throw Exception('Failed to fetch products');
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
    print(futureProducts);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Wrap(
            children: snapshot.data!
                .map((product) => ProductItem(product: product))
                .toList(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showLoadingScreen(context, destination: const ProductDetailScreen());
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Imagen del producto con manejo de errores
              Image.network(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
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
                    // Descripción del producto con valor por defecto
                    Text(
                      product.description.isNotEmpty
                          ? product.description
                          : 'No description available',
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
                  // Precio del producto
                  Text(
                    '\$${product.price}',
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
            ],
          ),
        ),
      ),
    );
  }
}
