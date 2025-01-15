import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_detail.dart';
import 'package:godeliveryapp_naranja/core/widgets/counterManager.dart';
import 'package:godeliveryapp_naranja/features/discount/discount_price_display.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:photo_view/photo_view.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int quantity = 1;
  num price = 0; // Divisa del precio

  int _currentIndex = 0; // Variable para el índice de la barra de navegación
  bool _isAutoPlay = true; // Variable para controlar el auto play del carrusel

  // Función para manejar el cambio de índice en el navbar
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    price = widget.product.price;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
      price = widget.product.price * quantity;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
          quantity--;
          price = widget.product.price * quantity;
      });
    }
  }

  void resetQuantity() {
    setState(() {
      quantity = 1;
      price = widget.product.price; // Vuelve al precio original del combo
    });
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
                    color: Color.fromARGB(185, 204, 204, 204),
                    width: 2,
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
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: PhotoView(
                        imageProvider: NetworkImage(imageUrl),
                        loadingBuilder: (context, event) => Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF9027),
                          ),
                        ),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
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
          'Detalle Producto',
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
                  Stack(
                    children: [
                      CarouselSlider(
                        items: widget.product.image.map((imageUrl) {
                          return GestureDetector(
                            onTap: () {
                              _showLargeImage(context, imageUrl);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                height: 180,
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
                          autoPlay: _isAutoPlay,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          enableInfiniteScroll: true,
                          initialPage: 0,
                          viewportFraction:
                              0.8, // Aumenta la proporción de la imagen visible
                          autoPlayInterval: Duration(
                              seconds:
                                  3), // Ajusta el intervalo de reproducción automática
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          pauseAutoPlayOnTouch: true,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(
                            _isAutoPlay ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isAutoPlay = !_isAutoPlay;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Indicadores de página
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.product.image.map((url) {
                      int index = widget.product.image.indexOf(url);
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
                  const SizedBox(height: 18),
                  // Nombre del producto más destacado
                  Center(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Descripción
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  // Presentación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Presentación',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 175, 91, 7),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.product.weight} gramos',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  DiscountPriceDisplay(
                    specialPrice: widget.product.price,
                    discountId: widget.product.discount,
                    currency: widget.product.currency,
                    quantity: quantity,
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
                    backgroundColor: quantity <= 1
                        ? Color.fromARGB(255, 206, 205, 204)
                        : Color(0xFFFF9027),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(fontSize: 24),
                  ),
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
                    product: widget.product,
                    quantity: quantity,
                    price: price,
                    resetQuantity: resetQuantity,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
