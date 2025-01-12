import 'package:flutter/material.dart';

// Tema Claro
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white, // Fondo blanco
    foregroundColor: Colors.black, // Texto e íconos en negro
    elevation: 4,
  ),
);

// Tema Oscuro
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black, // Fondo negro
    foregroundColor: Colors.white, // Texto e íconos en blanco
    elevation: 4,
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
