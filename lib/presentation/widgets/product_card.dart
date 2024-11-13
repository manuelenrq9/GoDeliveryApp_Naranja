import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/entities/product.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse(
      'https://orangeteam-deliverybackend-production.up.railway.app/product'));

  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> productsData = jsonData['products'];
    return productsData
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
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
            print("entro en el IF");
            print(snapshot.data!.length);
            return Wrap(
              children: snapshot.data!
                  .map((product) => ProductItem(product: product))
                  .toList(),
            );
          } else if (snapshot.hasError) {
            print("entro en el ELSE");
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
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
          ],
        ),
      ),
    );
  }
}
