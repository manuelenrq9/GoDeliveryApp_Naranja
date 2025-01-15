import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> _getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token'); // Obtén el token almacenado
}

Future<void> cancelOrder(String orderId) async {
  // Data to patch
  final patchData = {
    'status': 'CANCELLED',
  };

  try {

    final token = await _getToken();

    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final response = await http.patch(
      Uri.parse('https://orangeteam-deliverybackend-production.up.railway.app/order/update/$orderId'),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(patchData),
    );

    if (response.statusCode == 200) {
      print('Order status updated successfully');
    } else {
      print('Failed to update order status');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error updating order status: $e');
  }
}

