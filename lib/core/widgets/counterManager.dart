import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterManager {
  static final CounterManager _instance = CounterManager._internal();

  factory CounterManager() => _instance;

  CounterManager._internal() {
    loadCounterFromStorage(); // Cargar el valor del contador al inicializar
  }

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  ValueNotifier<int> get counterNotifier => _counter;

  int get counter => _counter.value;

  // Incrementar y guardar el valor
  void increment() {
    _counter.value++;
    _saveCounterToStorage();
  }

  // Decrementar y guardar el valor
  void decrement() {
    if (_counter.value > 0) {
      _counter.value--;
      _saveCounterToStorage();
    }
  }

  // Resetear y guardar el valor
  void reset() {
    _counter.value = 0;
    _saveCounterToStorage();
  }

  // Guardar el contador en almacenamiento local
  Future<void> _saveCounterToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter.value);
  }

  // Cargar el contador desde el almacenamiento local
  Future<void> loadCounterFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _counter.value = prefs.getInt('counter') ?? 0;
  }
}
