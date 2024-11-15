import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/product/data/product_fetchID.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/product_detail.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';  // Importar el paquete

class ComboDetailScreen extends StatefulWidget {
  final Combo combo;
  const ComboDetailScreen({super.key, required this.combo});

  @override
  ComboDetailScreenState createState() => ComboDetailScreenState();
}

class ComboDetailScreenState extends State<ComboDetailScreen> {
  int quantity = 1;
  num price = 0;
  late Future<List<Product>> _productsFuture;  // Future para cargar los productos
  List<Product> _productList = []; 

  @override
  void initState() {
    super.initState();
    price = widget.combo.specialPrice;
    _productsFuture = getProductsForCombo();
  }

  // Variable para el índice de la barra de navegación
  int _currentIndex = 0;

  // Función para manejar el cambio de índice en el navbar
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
      price = widget.combo.specialPrice * quantity;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        price = widget.combo.specialPrice * quantity;
      }
    });
  }

  

  // Verificar la conectividad antes de hacer la solicitud
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<Product>> getProductsForCombo() async {
    if (!await hasInternetConnection()) {
      throw 'No tienes conexión a internet';  // Lanzar un error si no hay conexión
    }

    List<Product> productList = [];
    for (var productId in widget.combo.products) {
      Product product = await fetchProductById(productId);
      productList.add(product);
    }
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Detalle Combo',
          style: TextStyle(
            color: Color.fromARGB(255, 175, 91, 7),
            fontSize: 24,
            fontWeight: FontWeight.bold,
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
            icon: const Icon(Icons.shopping_cart,
                color: Color.fromARGB(255, 175, 91, 7)),
            onPressed: () {
              showLoadingScreen(context, destination: const CartScreen());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.combo.comboImage,
                      height: 150,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                        color: Colors.orange,
                      )),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      widget.combo.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Divider(color: Colors.grey[300]),
                  Text(
                    'Productos Incluidos',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                                    FutureBuilder<List<Product>>(
                    future: _productsFuture,  // Future cargado al entrar
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(color: Colors.orange));
                      }

                      if (snapshot.hasError) {
                        // Si no hay conexión, mostrar el mensaje de error
                        if (snapshot.error == 'No tienes conexión a internet') {
                          return const Center(
                            child: Text(
                              'No tienes conexión a internet',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          );
                        }
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No hay productos disponibles.'));
                      }

                      return SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.map((product) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Navegar al detalle del producto
                                  showLoadingScreen(context, destination: ProductDetailScreen(product: product));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: product.image,
                                  width: 50,
                                  height: 50,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(color: Colors.orange)),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripción',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(
                          height: 4), // Espacio entre el título y el detalle
                      Text(
                        widget.combo
                            .description, // Cambia esto a la descripción que corresponda
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Precio',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color(0xFFFF9027),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: decrementQuantity,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color.fromARGB(255, 175, 91, 7),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: incrementQuantity,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color.fromARGB(255, 175, 91, 7),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Añadir carrito en futuras actualizaciones :c'),
                        duration: Duration(seconds: 2), 
                        backgroundColor: Colors.green,// Duración del mensaje
                      ),
                    );
                    },
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    label: const Text(
                      'Añadir al carrito',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9027),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      // Agregar CustomNavBar en el bottomNavigationBar
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
