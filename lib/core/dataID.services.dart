import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> _getApi() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('api_url'); // Obtén el token almacenado
}

Future<T> fetchEntityById<T>(String id, String endpoint,
    T Function(Map<String, dynamic>) fromJson) async {
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

    final response = await http.get(
      Uri.parse('$apiUrl/$endpoint$id'),
      headers: {
        'Authorization': 'Bearer $token', // Incluimos el token en el encabezado
        'Content-Type': 'application/json',
      },
    );
    print('URL DE FETCH ID $apiUrl/$endpoint$id');
    print('Status code ${response.statusCode}');
    print('${response.body}');
    if (response.statusCode == 200) {
      print('Entro al response');
      final jsonData = jsonDecode(response.body);
      final entityData = jsonData;
      print('jsonData $jsonData');
      print('entityData ${fromJson(entityData)}');
      return fromJson(entityData);
    } else {
      throw Exception('Failed to fetch entity');
    }
  } catch (e) {
    if (e is SocketException) {
      throw 'No tienes conexión a Internet';
    } else {
      throw Exception('Error al cargar la entidad');
    }
  }
}
