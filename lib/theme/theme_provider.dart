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
  primaryColor: const Color.fromARGB(255, 61, 33, 187),
  scaffoldBackgroundColor: const Color.fromARGB(255, 241, 97, 7),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 255, 12, 12),
    elevation: 0,
    foregroundColor: const Color.fromARGB(255, 183, 43, 43),
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.orange),
  ),
);
