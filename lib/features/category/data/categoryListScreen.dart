import 'dart:async';
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

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loadCategories();
    startAutoScroll();
  }

  void loadCategories() async {
    futureCategories = _categoryService.loadData();
    setState(() {});
  }

  void startAutoScroll() {
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double nextScroll = currentScroll + 200;

        if (nextScroll > maxScroll) {
          nextScroll = 0;
          _scrollController.jumpTo(0); // Saltar al inicio sin animación
        } else {
          _scrollController.animateTo(
            nextScroll,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: categories.map((category) {
                return CategoryCard(category: category);
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        },
      ),
    );
  }
}
