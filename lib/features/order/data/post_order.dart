import 'dart:convert';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:http/http.dart' as http;

class PostOrder{
  Future<http.Response> postOrder(Order order) async {
  final url = Uri.parse('YOUR_BACKEND_ENDPOINT'); // Replace with your actual endpoint

  // Convert order object to JSON
  final body = json.encode({
    'address': order.address,
    'products': order.products.map((product) => {
      'id': product.id, 
    }).toList(),
    'combos': order.combos.map((combo) => {
      'id': combo.id,
      'quantity': 1, // Replace with quantity if applicable
    }).toList(),
    'paymentMethod': order.paymentMethod,
    // Include 'currency' if required by your backend
    // 'currency': 'USD', // Example
  });

  // Create POST request
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  return response;
}
}