import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<T> fetchEntityById<T>(String id, String endpoint, T Function(Map<String, dynamic>) fromJson) async {
  // Método para obtener el token de SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Obtén el token almacenado
  }

  try {
    final token = await _getToken();

    // Si no hay token, puede que quieras manejarlo, como redirigir al login
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final response = await http.get(
      Uri.parse('https://orangeteam-deliverybackend-production.up.railway.app/$endpoint/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Incluimos el token en el encabezado
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final entityData = jsonData['value']; // Acceder al objeto dentro de "value"
      return fromJson(entityData);
    } else {
      print("Failed to fetch entity, status code: ${response.statusCode}");
      throw Exception('Failed to fetch entity');
    }
  } catch (e) {
    if (e is SocketException) {
      print("No internet connection");
      throw 'No tienes conexión a Internet';
    } else {
      print("Error fetching entity: $e");
      throw Exception('Error al cargar la entidad');
    }
  }
}
