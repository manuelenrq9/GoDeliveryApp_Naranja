import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> _getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token'); // Obtén el token almacenado
}

Future<String?> _getApi() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('api_url'); // Obtén el token almacenado
}

Future<void> processOrder({
  required String address,
  required List<CartProduct> products,
  required List<CartCombo> combos,
  required String? paymentMethod,
  required String currency,
  required num totalDecimal,
  required double latitude,
  required double longitude,
  required String cupon,
  required BuildContext context,
}) async {
  // Estructura de la orden que se enviará al backend
  final apiUrl = await _getApi();
  var orderData = {};
  if (apiUrl == 'https://amarillo-backend-production.up.railway.app') {
     orderData = {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
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
      // 'currency': currency,
      'idPayment': "56dc5446-67c1-4a8f-b1e8-860a9293617d",
      // 'total': double.parse(totalDecimal.toStringAsFixed(2)),
      if (cupon != '') ...{
        'cupon_code': cupon,
      }
    };
  } else {
    orderData = {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
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
      'paymentMethod': 'Efectivo',
      'currency': currency,
      'total': double.parse(totalDecimal.toStringAsFixed(2)),
      'cupon_code': cupon,
    };
  }
  try {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    // Imprimir datos antes de hacer la solicitud
    print('Datos de la solicitud: ${json.encode(orderData)}');

    final response = await http.post(
      Uri.parse('$apiUrl/order/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(orderData),
    );
    print('$apiUrl/order/create');
    if (response.statusCode == 201) {
      // Si la orden fue procesada con éxito, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Orden creada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );

      // Espera un momento y redirige al menú principal
      await Future.delayed(Duration(seconds: 2));
      await CartScreen.clearCartStatic(context);

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
