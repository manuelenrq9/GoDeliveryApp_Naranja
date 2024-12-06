import 'dart:convert';
import 'dart:io';
import 'package:godeliveryapp_naranja/features/discount/domain/discount.dart';
import 'package:http/http.dart' as http;

Future<Discount> fetchDiscountById(String? discountId) async {
  try {
    final response = await http.get(Uri.parse(
        //'https://orangeteam-deliverybackend-production.up.railway.app/discount/$discountId'));
        'http://192.168.68.113:3000/discount/$discountId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // Acceder a la propiedad 'value' que contiene el descuento
      final discountData = jsonData['value'];
      return Discount.fromJson(discountData);
    } else {
      print("Failed to fetch discount, status code: ${response.statusCode}");
      throw Exception('Failed to fetch discount');
    }
  } catch (e) {
    if (e is SocketException) {
      print("No internet connection");
      throw 'No tienes conexión a Internet';
    } else {
      print("Error fetching discount: $e");
      throw Exception('Error al cargar el descuento');
    }
  }
}
