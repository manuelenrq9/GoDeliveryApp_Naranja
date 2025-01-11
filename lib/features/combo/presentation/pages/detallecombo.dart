import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/getEntitiesById.services.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_detail.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/discount/discount_price_display.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/product_detail.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Importar el paquete
import 'package:photo_view/photo_view.dart';

class ComboDetailScreen extends StatefulWidget {
  final Combo combo;
  const ComboDetailScreen({super.key, required this.combo});

  @override
  ComboDetailScreenState createState() => ComboDetailScreenState();
}

class ComboDetailScreenState extends State<ComboDetailScreen> {
  int quantity = 1;
  num price = 0;
  late Future<List<Product>> _productsFuture;
  bool isAddedToCart = false;

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

  void resetQuantity() {
    setState(() {
      quantity = 1;
      price = widget.combo.specialPrice;
    });
  }

  // Verificar la conectividad antes de hacer la solicitud
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // Future<List<Product>> getProductsForCombo() async {
  //   if (!await hasInternetConnection()) {
  //     throw 'No tienes conexión a internet';
  //   }

  //   List<Product> productList = [];
  //   for (var productId in widget.combo.products) {
  //     Product product = await fetchProductById(productId);
  //     productList.add(product);
  //   }
  //   return productList;
  // }

  Future<List<Product>> getProductsForCombo() async {
    return await getEntitiesByIds<Product>(
      widget.combo.products,
      'product/one',
      (json) => Product.fromJson(json),
    );
  }

  // Función para mostrar la imagen en tamaño grande con zoom
  void _showLargeImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFFF9027),
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PhotoView(
                    imageProvider: NetworkImage(imageUrl),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF9027),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
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
      body: SingleChildScrollView(
        child: Padding(
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
                      color: Colors.grey,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Carrusel de imágenes
                    CarouselSlider(
                      items: widget.combo.comboImage.map((imageUrl) {
                        return GestureDetector(
                          onTap: () {
                            _showLargeImage(context, imageUrl);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              height: 168,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.orange)),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: true,
                        initialPage: 0,
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
                    const Text('Productos Incluidos',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 175, 91, 7),
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    // FutureBuilder para cargar productos
                    SizedBox(
                      height: 100, // Limitar la altura del ListView horizontal
                      child: FutureBuilder<List<Product>>(
                        future: _productsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.orange));
                          }

                          if (snapshot.hasError) {
                            if (snapshot.error ==
                                'No tienes conexión a internet') {
                              return const Center(
                                child: Text(
                                  'No tienes conexión a internet',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                ),
                              );
                            }
                            return Center(
                                child: Text('Errorr: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No hay productos disponibles.'));
                          }

                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.map((product) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    showLoadingScreen(context,
                                        destination: ProductDetailScreen(
                                            product: product));
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: product.image[0],
                                    width: 80,
                                    height: 80,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.orange)),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 4),
                    // Descripción del combo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Descripción',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 175, 91, 7),
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(widget.combo.description,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 4),
                    // Precio
                    DiscountPriceDisplay(
                      specialPrice: widget.combo.specialPrice,
                      discountId: widget.combo.discount,
                      currency: widget.combo.currency,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: decrementQuantity,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: quantity > 1
                          ? Color.fromARGB(255, 206, 205, 204)
                          : Color(0xFFFF9027),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.remove, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        Text('$quantity', style: const TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: incrementQuantity,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Color(0xFFFF9027),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AddToCartButton(
                      combo: widget.combo,
                      quantity: quantity,
                      price: price,
                      resetQuantity: resetQuantity,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
