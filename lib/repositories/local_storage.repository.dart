import 'dart:convert';
import 'package:godeliveryapp_naranja/services/local_storage.services.dart';

class GenericRepository<T> {
  final String storageKey;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  GenericRepository({
    required this.storageKey,
    required this.fromJson,
    required this.toJson,
  });

  Future<void> saveData(List<T> data) async {
    await LocalStorageService.saveData<T>(
      storageKey,
      data,
      (item) => toJson(item), // Convert the item to JSON before saving
    );
  }

  Future<List<T>> loadData() async {
    return await LocalStorageService.loadData<T>(
      storageKey,
      (json) => fromJson(json), // Convert JSON back to item
    );
  }
}