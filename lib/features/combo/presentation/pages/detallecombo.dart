import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';

class ComboDetailScreen extends StatefulWidget {
  final Combo combo;
  const ComboDetailScreen({super.key, required this.combo});

  @override
  ComboDetailScreenState createState() => ComboDetailScreenState();
}

class ComboDetailScreenState extends State<ComboDetailScreen> {
  int quantity = 1;
  num price = 0;

  @override
  void initState() {
    super.initState();
    price = widget.combo.specialPrice;
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
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.orange,)),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      widget.combo.name,
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: Colors.grey[300]),
                  const Text(
                    'Productos Incluidos',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        Text(
                          'Nombre',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          'Combo Mensual',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 8),
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
              const SizedBox(height: 16),
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
                  const SizedBox(height: 8),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripción',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 4), // Espacio entre el título y el detalle
                      Text(
                        widget.combo.description, // Cambia esto a la descripción que corresponda
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
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
                      onPressed: () {},
                      icon:
                          const Icon(Icons.shopping_cart, color: Colors.white),
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

