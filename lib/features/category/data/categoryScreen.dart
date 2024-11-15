import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/category/domain/category.dart';
import 'package:godeliveryapp_naranja/features/category/presentation/widgets/category_card.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:godeliveryapp_naranja/features/sidebar/presentation/custom_drawer.dart';

Future<List<Category>> fetchCategories() async {
  try {
    final response = await http.get(Uri.parse('https://orangeteam-deliverybackend-production.up.railway.app/category'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> categoriesData = jsonData['categories'];
      return categoriesData.map((categoryJson) => Category.fromJson(categoryJson)).toList();
    } else {
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

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Category>> futureCategories = Future.value([]);

  // Repositorio para manejar las categorías en almacenamiento local
  final _categoryRepository = GenericRepository<Category>(
    storageKey: 'categories', // Clave para el almacenamiento local
    fromJson: (json) => Category.fromJson(json), // Función de deserialización
    toJson: (category) => category.toJson(), // Función de serialización
  );

  @override
  void initState() {
    super.initState();
    loadCategories(); // Cargar categorías al inicio
  }

  // Método que carga las categorías desde la API o desde el almacenamiento local
  void loadCategories() async {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      // Si hay conexión, obtenemos las categorías desde la API
      try {
        final categories = await fetchCategories();
        await _categoryRepository.saveData(categories); // Guardamos en el almacenamiento local
        setState(() {
          futureCategories = Future.value(categories); // Actualizamos el future con los datos obtenidos
        });
      } catch (error) {
        setState(() {
          futureCategories = Future.value([]); // Si hay error, mostramos una lista vacía
        });
        print('Error al obtener categorías desde la API: $error');
      }
    } else {
      // Si no hay conexión, cargamos las categorías desde el almacenamiento local
      final savedCategories = await _categoryRepository.loadData();
      setState(() {
        futureCategories = Future.value(savedCategories.isNotEmpty ? savedCategories : []);
      });
    }
  }

  // Método para refrescar las categorías (simula una actualización de datos)
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    loadCategories(); // Recargamos las categorías
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Center(
          child: Image.asset(
            'images/LogoLetrasGoDely.png', // Ruta de tu logo
            height: 40,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Acción para abrir la búsqueda
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.orange,
        child: ListView(
          padding: const EdgeInsets.all(8.0), // Padding para el contenido
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            FutureBuilder<List<Category>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final categories = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, 
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(category: categories[index]);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator(color: Colors.orange));
              },
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}
