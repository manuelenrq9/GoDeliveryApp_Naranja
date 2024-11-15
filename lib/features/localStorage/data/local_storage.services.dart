import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  // Guardar una lista de objetos
  static Future<void> saveData<T>(
    String key,
    List<T> data,
    Map<String, dynamic> Function(T) encodeFunction,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> dataList = data.map(encodeFunction).toList();
    final String dataJson = jsonEncode(dataList); // Almacena una lista de Map
    await prefs.setString(key, dataJson);
  }

  // Cargar una lista de objetos
  static Future<List<T>> loadData<T>(
    String key,
    T Function(Map<String, dynamic>) decodeFunction,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataJson = prefs.getString(key);
    if (dataJson != null) {
      final List<dynamic> dataList = jsonDecode(dataJson);
      // Verifica si `dataList` contiene un `Map<String, dynamic>`
      return dataList.map((item) {
        if (item is Map<String, dynamic>) {
          return decodeFunction(item);
        } else if (item is String) {
          // Decodifica si el elemento es un String
          final Map<String, dynamic> decodedItem = jsonDecode(item);
          return decodeFunction(decodedItem);
        } else {
          throw TypeError();
        }
      }).toList();
    }
    return [];
  }
}
