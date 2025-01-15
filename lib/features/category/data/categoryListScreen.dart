import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/category/domain/category.dart';
import 'package:godeliveryapp_naranja/features/category/presentation/widgets/category_card.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late Future<List<Category>> futureCategories = Future.value([]);
  late final DataService<Category> _categoryService = DataService<Category>(
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
    loadCategories();
  }

  void loadCategories() async {
    futureCategories = _categoryService.loadData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155,
      child: FutureBuilder<List<Category>>(
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
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.orange,
          ));
        },
      ),
    );
  }
}
