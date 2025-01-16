import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/widgets/productitemCatalogo.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';

class ProductCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String titulo;
  const ProductCategoryScreen(
      {super.key, required this.categoryId, required this.titulo}); // Nombre actualizado

  @override
  State<ProductCategoryScreen> createState() =>
      _ProductCatalogScreenState(); // Nombre actualizado
}

class _ProductCatalogScreenState extends State<ProductCategoryScreen> {
  // Nombre actualizado
  late Future<List<Product>> futureProducts;
  late final DataService<Product> productService = DataService<Product>(
    endpoint: '/product/many?category=${widget.categoryId}',
    repository: GenericRepository<Product>(
      storageKey: 'products',
      fromJson: (json) => Product.fromJson(json),
      toJson: (product) => product.toJson(),
    ),
    fromJson: (json) => Product.fromJson(json),
  );

  @override
  void initState() {
    super.initState();
    loadProducts(); // Cargar los productos desde el API
  }

  void loadProducts() {
    setState(() {
      futureProducts = productService.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: Text(
            '${widget.titulo}',
            style: TextStyle(
              color: Color.fromARGB(255, 175, 91, 7),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 175, 91, 7)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.transparent,),
            onPressed: () {
              // Acción para abrir la búsqueda
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos disponibles'));
          } else {
            // Si hay productos, los mostramos
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 1, // Espaciado horizontal entre columnas
                mainAxisSpacing: 1, // Espaciado vertical entre filas
                childAspectRatio: 0.85, // Relación de aspecto de las tarjetas
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductItemCatalogo(
                    product: products[
                        index]); // Este es el widget que muestra el producto
              },
            );
          }
        },
      ),
    );
  }
}
