import 'package:flutter/material.dart';

// Tema Claro
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
final ThemeData orangeGradientTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
    elevation: 0,
  ),
  scaffoldBackgroundColor: Colors.transparent,
);
