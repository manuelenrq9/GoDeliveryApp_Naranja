import 'dart:convert';
import 'dart:io';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

  Future<String?> _getApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_url'); // Obtén el token almacenado
  }

Future<Product> fetchProductById(String productId) async {
  // Método para obtener el token de SharedPreferences
    Future<String?> _getToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token'); // Obtén el token almacenado
    }
      final apiUrl = await _getApi();
  try {
    final token = await _getToken();

      // Si no hay token, puede que quieras manejarlo, como redirigir al login
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

    final response = await http.get(Uri.parse(
        '$apiUrl/product/$productId'),
        headers: {
          'Authorization':
              'Bearer $token', // Incluimos el token en el encabezado
          'Content-Type': 'application/json',
        },
      );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // Acceder a la propiedad 'value' que contiene el producto
      final productData = jsonData;
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
