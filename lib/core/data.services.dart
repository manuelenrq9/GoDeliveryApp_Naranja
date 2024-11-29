import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';

class DataService<T> {
  static const String baseUrl = 'https://orangeteam-deliverybackend-production.up.railway.app';

  final String endpoint;
  final GenericRepository<T> repository;
  final T Function(Map<String, dynamic>) fromJson;

  DataService({
    required this.endpoint,
    required this.repository,
    required this.fromJson,
  });

  String get apiUrl => '$baseUrl$endpoint';

  Future<List<T>> fetchDataFromApi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> items =
            jsonData['${T.toString().toLowerCase()}s']; // Asume plural
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
        final data = await fetchDataFromApi();
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
