import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Obtén el token almacenado
  }

Future<void> processOrder({
  required String address,
  required List<CartProduct> products,
  required List<CartCombo> combos,
  required String? paymentMethod,
  required String currency,
  required num totalDecimal,
  required String userId,
  required BuildContext context, 
}) async {
  final int total = totalDecimal.toInt();
  // Estructura de la orden que se enviará al backend
  final orderData = {
    'userId': userId,
    'address': address,
    'products': products.map((product) {
      return {
        'id': product.id,
        'quantity': product.quantity,
      };
    }).toList(),
    'combos': combos.map((combo) {
      return {
        'id': combo.id,
        'quantity': combo.quantity,
      };
    }).toList(),
    'paymentMethod': paymentMethod,
    'currency': currency,
    'total': total,
  };

  try {
  final token = await _getToken();
  
  if (token == null) {
    throw Exception('No hay token de autenticación');
  }
  
  // Imprimir datos antes de hacer la solicitud
  print('Datos de la solicitud: ${json.encode(orderData)}');
  
  final response = await http.post(
    Uri.parse('https://orangeteam-deliverybackend-production.up.railway.app/order'),
    headers: {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode(orderData),
  );

  // Imprimir la respuesta completa para ver el error detallado
  print('Response Status: ${response.statusCode}');
  print('Response Body: ${response.body}');
  
  if (response.statusCode == 201) {
    print('Orden procesada correctamente');
    // Si la orden fue procesada con éxito, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Orden creada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );

      // Espera un momento y redirige al menú principal
      await Future.delayed(Duration(seconds: 2));

      // Redirigir al menú principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainMenu()),
      );
    
  } else {
    print('Error al procesar la orden: ${response.body}');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al procesar la orden'),
          backgroundColor: Colors.red,
        ),
      );
  }
} catch (e) {
  print('Error al hacer la solicitud: $e');
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error en la conexión, por favor intente nuevamente'),
        backgroundColor: Colors.red,
      ),
    );
}


}
