import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/category/domain/category.dart';
import 'package:godeliveryapp_naranja/features/category/presentation/widgets/category_card.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:http/http.dart' as http;

Future<List<Category>> fetchCategories() async {
  try {  
    final response = await http.get(Uri.parse('https://orangeteam-deliverybackend-production.up.railway.app/category'));
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
  } catch (e) {
    if (e is SocketException) {
      throw 'No tienes conexión a Internet';
    } else {
      throw Exception('Error al cargar las categorías');
    }
  }  
}

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late Future<List<Category>> futureCategories = Future.value([]); // Inicializamos el future vacío

  // Repositorio para manejar las categorías en almacenamiento local
  final _categoryRepository = GenericRepository<Category>(
    storageKey: 'categories', // Clave para el almacenamiento local
    fromJson: (json) => Category.fromJson(json), // Función de deserialización
    toJson: (category) => category.toJson(), // Función de serialización
  );

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

    // Método que carga las categorías desde la API o desde el almacenamiento local
  void loadCategories() async {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      // Hay conexión a Internet, obtenemos las categorías de la API
      try {
        final categories = await fetchCategories(); // Obtenemos las categorías desde la API
        await _categoryRepository.saveData(categories); // Guardamos las categorías en el almacenamiento local
        setState(() {
          futureCategories = Future.value(categories); // Actualizamos el Future con las categorías obtenidas
        });
      } catch (error) {
        setState(() {
          futureCategories = Future.value([]); // Si ocurre un error, mostramos una lista vacía
        });
        print('Error al obtener categorías desde la API: $error');
      }
    } else {
      // Si no hay conexión a Internet, cargamos las categorías desde el almacenamiento local
      final savedCategories = await _categoryRepository.loadData();
      setState(() {
        futureCategories = Future.value(savedCategories.isNotEmpty ? savedCategories : []); // Si no hay categorías, mostramos una lista vacía
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child:FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categories = snapshot.data!;
            return ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((category) {
                return CategoryCard(category: category);
              }).toList(),
            );
          } else if (snapshot.hasError) { 
            // Si hay un error, mostramos el mensaje de error
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Si está esperando la respuesta, mostramos un indicador de carga
          return const Center(child: CircularProgressIndicator(color: Colors.orange,));
        },
      ),
    );
  }
}
