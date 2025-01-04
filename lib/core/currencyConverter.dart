import 'package:dart_bcv/dart_bcv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyConverter {
  static final CurrencyConverter _instance = CurrencyConverter._internal();
  factory CurrencyConverter() => _instance;

  CurrencyConverter._internal() {
    _loadSelectedCurrency(); // Cargar la moneda al inicializar
  }

  String _selectedCurrency = 'USD'; // Moneda por defecto
  Map<String, double> _rates = {'USD': 1.0}; // Tasas de conversión (USD base)

  // Obtener la moneda seleccionada
  String get selectedCurrency => _selectedCurrency;

  // Cambiar la moneda seleccionada y guardar en almacenamiento persistente
  Future<void> setCurrency(String currency) async {
    _selectedCurrency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency); // Guardar la moneda
  }

  // Cargar la moneda seleccionada desde almacenamiento persistente
  Future<void> _loadSelectedCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCurrency = prefs.getString('selectedCurrency') ?? 'USD'; // Predeterminado: USD
  }

  // Obtener las tasas de conversión desde el BCV
Future<void> updateRates() async {
  _rates = {
    'USD': double.tryParse(await BCVWebSite.getRates(currencyCode: 'USD')) ?? 1.0,
    'EUR': double.tryParse(await BCVWebSite.getRates(currencyCode: 'EUR')) ?? 1.0,
  };
}


  // Convertir un precio según la moneda seleccionada
  double convert(double priceInUSD) {
    if (_selectedCurrency == 'VES') {
      return priceInUSD * (_rates['USD'] ?? 1.0);
    }
    if (_selectedCurrency == 'EUR') {
      return (priceInUSD * (_rates['USD'] ?? 1.0)) / (_rates['EUR'] ?? 1.0);
    }
    return priceInUSD;
  }
}
