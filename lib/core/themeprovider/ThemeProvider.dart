import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _themeName = 'light';

  ThemeMode get themeMode => _themeMode;

  Future<void> loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _themeName = prefs.getString('theme') ?? 'light';
    _updateThemeMode();
  }

  Future<void> saveThemeToPreferences(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeName);
  }

  void setTheme(String themeName) {
    _themeName = themeName;
    _updateThemeMode();
    saveThemeToPreferences(themeName);
    notifyListeners();
  }

  void _updateThemeMode() {
    if (_themeName == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (_themeName == 'gradient') {
      _themeMode = ThemeMode.light; // Usa ThemeMode.light para degradado
    } else {
      _themeMode = ThemeMode.light;
    }
  }

  ThemeData getThemeData() {
    if (_themeName == 'dark') {
      return darkTheme;
    } else if (_themeName == 'gradient') {
      return gradientTheme;
    } else {
      return lightTheme;
    }
  }
}
