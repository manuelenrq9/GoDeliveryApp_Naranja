import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/getEntitiesById.services.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_detail.dart';
import 'package:godeliveryapp_naranja/core/widgets/counterManager.dart';
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

class ComboDetailScreenState extends State<ComboDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int quantity = 1;
  num price = 0;
  late Future<List<Product>> _productsFuture;
  bool isAddedToCart = false;
  bool _isAutoPlay = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
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
    if (quantity > 1) {
      setState(() {
          quantity--;
          price = widget.combo.specialPrice * quantity; 
      });
    }
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
      'product/one/',
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
                    color: Color.fromARGB(237, 238, 237, 236),
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
  Widget _buildCartIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.shopping_cart,
            color: Color.fromARGB(255, 175, 91, 7),
            size: 28,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.2).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticOut,
              ),
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: CounterManager().counterNotifier,
              builder: (context, counter, child) {
                return Visibility(
                  visible: counter > 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$counter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
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
            icon: _buildCartIcon(),
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 36, 36, 36)
                      : Colors.white,
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
                    Stack(
                      children: [
                        CarouselSlider.builder(
                          itemCount: widget.combo.comboImage.length,
                          itemBuilder: (context, index, realIndex) {
                            final imageUrl = widget.combo.comboImage[index];
                            return GestureDetector(
                              onTap: () {
                                _showLargeImage(context, imageUrl);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      height: 180,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.orange)),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 200,
                            autoPlay: _isAutoPlay,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            enableInfiniteScroll: true,
                            initialPage: 0,
                            viewportFraction: 0.8,
                            autoPlayInterval: const Duration(seconds: 3),
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            pauseAutoPlayOnTouch: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Indicadores de página
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.combo.comboImage.map((url) {
                        int index = widget.combo.comboImage.indexOf(url);
                        return Container(
                          width: 12.0,
                          height: 12.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Color(0xFFFF9027)
                                : Colors.grey,
                          ),
                        );
                      }).toList(),
                    ),
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
                        Text(
                          widget.combo.description,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
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
                      quantity: quantity
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
                      backgroundColor: quantity <= 1
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
