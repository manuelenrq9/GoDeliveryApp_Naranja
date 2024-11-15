import 'dart:convert';
import 'dart:io';

import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:http/http.dart' as http;

Future<Product> fetchProductById(String productId) async {
  try {
    final response = await http.get(Uri.parse(
        'https://orangeteam-deliverybackend-production.up.railway.app/product/$productId'));
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // Acceder a la propiedad 'value' que contiene el producto
      final productData = jsonData['value'];
      return Product.fromJson(productData);
    } else {
      print("Failed to fetch product, status code: ${response.statusCode}");
      throw Exception('Failed to fetch product');
    }
  } catch (e) {
    if (e is SocketException) {
      print("No internet connection");
      throw 'No tienes conexión a Internet';
    } else {
      print("Error fetching product: $e");
      throw Exception('Error al cargar el producto');
    }
  }
}

