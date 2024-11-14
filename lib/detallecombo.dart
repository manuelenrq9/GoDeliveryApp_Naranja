import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/entities/combo.dart';
import 'package:godeliveryapp_naranja/orderhistory/navbar.dart';
import 'package:godeliveryapp_naranja/carrito/cart_screen.dart';
import 'package:godeliveryapp_naranja/presentation/interfaces/loading_screen.dart';

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
                    child: Image.network(
                      widget.combo.comboImage,
                      height: 150,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
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
                      children: [
                        Image.network(
                          //azuncar Montalban
                          'https://www.supergarzon.com/site/pueblonuevo/4009-large_default/azucar-montalban-1kg.jpg',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8),
                        Image.network(
                          // harina pan
                          'https://www.elbodegonactual.com/web/image/product.template/175169/image_512',
                          width: 40,
                          height: 30,
                        ),
                        const SizedBox(width: 8),
                        Image.network(
                          // salsa iglesa
                          'https://www.supermercadoluxor.com/wp-content/uploads/2020/11/SAL0485.jpg',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8),
                        Image.network(
                          //pasta ronco
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO1b-Gfh7BpXM5y2H8h2dfA_OLHOkyBbJeHQ&s',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8),
                        Image.network(
                          'https://vallearriba.elplazas.com/media/catalog/product/cache/3e568157972a1320c1e54e4ca9aac161/1/6/16001800un_3.jpg',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8),
                        Image.network(
                          'https://familybox.store/cdn/shop/products/mayonesa-cremosa-kraft-887-ml-enviar-a-venezuela-ship-to-venezuela-supermercado-online-venezuela-online-supermarket-624247_grande.jpg?v=1697811642',
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
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
        bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
      );
  }
}
