import 'package:flutter/material.dart';

// Tema Claro
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
  ),
);

// Tema Oscuro
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
);

// Tema con Degradado Naranja
final ThemeData gradientTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.orange,
  scaffoldBackgroundColor: Colors.orange[50],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.orange),
  ),
);
