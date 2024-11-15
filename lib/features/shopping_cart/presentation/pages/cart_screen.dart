import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/widgets/summary_row.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import '../../domain/cart_item_data.dart';
import '../widgets/cart_items_list.dart';
//import 'discount_section.dart'; // Comentado porque no se usará
import '../widgets/summary_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItemData> cartItems = [
    // Ejemplo de datos
    CartItemData(
      imageUrl:
          'https://lh3.googleusercontent.com/FirLkhJG0YgVeX_aQkP2tF7KWV6_CRHV8fX-9C-isPcpeUwK8MUAHtAruNBCuIds-NZyy9tu-hg3O6xblN5bUsT8wfg5a-aWVTIvMUqJpgDY0Ws',
      name: 'Galletas Oreo',
      presentation: '150 gr',
      price: 230,
      quantity: 3,
    ),
    CartItemData(
      imageUrl:
          'https://amarket.com.bo/cdn/shop/files/07591057001025_700x700.jpg?v=1712344200',
      name: 'Cereal corn flakes kellogg´s',
      presentation: '550 gm',
      price: 550,
      quantity: 1,
    ),
    CartItemData(
      imageUrl:
          'https://mi3monline.com/Productos/Imagen?codigo=368&ancho=150&alto=150',
      name: 'Lentejas la criolla',
      presentation: '50 gm',
      price: 120,
      quantity: 1,
    ),
    CartItemData(
      imageUrl:
          'https://www.tiendashoppi.com/cdn/shop/files/tienda-shoppi-barrita-de-avena-miel-y-granola-min.jpg?v=1697057321',
      name: 'Granola Nature Valley',
      presentation: '400 gr',
      price: 480,
      quantity: 2,
    ),
    // Agrega más productos aquí
  ];

  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  int _currentIndex = 0; // Variable para el índice de la barra de navegación

  // Función para manejar el cambio de índice en el navbar
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${cartItems.length} artículos',
              style: const TextStyle(color: Color(0xFFFF7000)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CartItemsList(
              cartItems: cartItems,
              onIncreaseQuantity: increaseQuantity,
              onDecreaseQuantity: decreaseQuantity,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ProductSummary(totalAmount: totalAmount),
                //DiscountSection(),
                const Divider(),
                const SummaryRow(label: 'Tarifa de envío', amount: '\$50'),
                const Divider(),
                SummaryRow(
                  label: 'Total',
                  amount: '\$${(totalAmount + 50 - 20).toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Acción para proceder al checkout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7000),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Procesar Orden',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      // Agregar CustomNavBar en el bottomNavigationBar
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
