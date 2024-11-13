import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/entities/category.dart';
import 'package:godeliveryapp_naranja/presentation/widgets/category_card.dart';
import 'package:http/http.dart' as http;

Future<List<Category>> fetchCategories() async {
  final response = await http.get(Uri.parse(''));
  if (response.statusCode == 200) {
    // Parseamos la respuesta JSON
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> categoriesData = jsonData[
        'categories']; // Cambia 'categories' según la respuesta de tu API
    return categoriesData
        .map((categoryJson) => Category.fromJson(
            categoryJson)) // Convierte el JSON a instancias de Category
        .toList();
  } else {
    // Si el servidor no devuelve una respuesta 200 OK
    throw Exception('Failed to fetch categories');
  }
}

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories =
        fetchCategories(); // Llamamos a la función que obtiene las categorías
    print(futureCategories); // Para debug
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              children: snapshot.data!
                  .map((category) => CategoryCard(category: category))
                  .toList(),
            );
          } else if (snapshot.hasError) {
            // Si hay un error, mostramos el mensaje de error
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Si está esperando la respuesta, mostramos un indicador de carga
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
