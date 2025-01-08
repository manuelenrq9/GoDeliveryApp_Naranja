import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/category/domain/category.dart';
import 'package:godeliveryapp_naranja/features/category/presentation/widgets/category_card.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/sidebar/presentation/custom_drawer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  late Future<List<Category>> futureCategories = Future.value([]);
  late final DataService<Category> _categoryService= DataService<Category>(
      endpoint: '/category/many',
      repository: GenericRepository<Category>(
        storageKey: 'categories',
        fromJson: (json) => Category.fromJson(json),
        toJson: (category) => category.toJson(),
      ),
      fromJson: (json) => Category.fromJson(json),
    );
    

  @override
  void initState() {
    super.initState();
    loadCategories(); // Cargar categorías al inicio
  }

  void loadCategories() async {
    futureCategories = _categoryService.loadData();
    setState(() {});
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
