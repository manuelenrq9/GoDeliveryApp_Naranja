import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataService<T> {
  static const String baseUrl =
      'https://orangeteam-deliverybackend-production.up.railway.app';
  // 'https://amarillo-backend-production.up.railway.app';
  //'http://192.168.68.113:3000';
  final String endpoint;
  final GenericRepository<T> repository;
  final T Function(Map<String, dynamic>) fromJson;

  DataService({
    required this.endpoint,
    required this.repository,
    required this.fromJson,
  });

  String get apiUrl => '$baseUrl$endpoint';

  // Método para obtener el token de SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Obtén el token almacenado
  }

  Future<List<T>> fetchDataFromApi() async {
    try {
      final token = await _getToken();

      // Si no hay token, puede que quieras manejarlo, como redirigir al login
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }
      print('FINAL');
      print(apiUrl);
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization':
              'Bearer $token', // Incluimos el token en el encabezado
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> items = jsonData;
        return items.map((item) => fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      if (e is SocketException) {
        throw 'No tienes conexión a Internet';
      } else {
        throw Exception('Error al cargar los datos');
      }
    }
  }

  Future<List<T>> loadData() async {
    final hasInternet = await _hasInternetConnection();

    if (hasInternet) {
      try {
        print("LOADDATA");
        final data = await fetchDataFromApi();
        print("DATA LOAD DATA ${data}");
        await repository.saveData(data);
        return data;
      } catch (e) {
        return await _loadFromLocal();
      }
    } else {
      return await _loadFromLocal();
    }
  }

  Future<List<T>> _loadFromLocal() async {
    final localData = await repository.loadData();
    return localData.isNotEmpty ? localData : [];
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
