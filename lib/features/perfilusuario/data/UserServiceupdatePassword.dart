import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // Método para obtener el token del usuario desde SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Método para obtener el UserID desde SharedPreferences
  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // Método reutilizable para actualizar la contraseña
  Future<bool> updatePassword(String newPassword) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No hay token de autenticación');

      final userId = await _getUserId();
      if (userId == null) throw Exception('No se encontró el ID del usuario');

      final response = await http.patch(
        Uri.parse(
            'https://orangeteam-deliverybackend-production.up.railway.app/User/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Contraseña actualizada con éxito
      } else {
        final errorMessage = json.decode(response.body)['message'] ??
            'Error desconocido al actualizar la contraseña';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error al cambiar contraseña: $e');
      throw Exception('Error al cambiar la contraseña: $e');
    }
  }
}
