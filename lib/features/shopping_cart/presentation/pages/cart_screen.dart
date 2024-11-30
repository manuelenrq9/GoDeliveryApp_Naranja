import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/card_repository.dart';
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
  late final CartRepository _cartRepository;
  List<CartItemData> cartItems = [];

  @override
  void initState() {
    super.initState();
    _cartRepository = CartRepository();
    _loadCart();
  }

  // Cargar los datos del carrito desde el almacenamiento local
  Future<void> _loadCart() async {
    final items = await _cartRepository.loadData();
    setState(() {
      cartItems = items;
    });
  }

  // Actualizar el carrito en el almacenamiento local
  Future<void> _updateCart() async {
    await _cartRepository.saveData(cartItems);
  }

  // Calcular el total del carrito
  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  // Incrementar la cantidad de un producto
  void increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
    _updateCart();
  }

  // Decrementar la cantidad de un producto
  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
    _updateCart();
  }

  // Eliminar un producto del carrito
  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
    _updateCart();
  }

  // Limpiar el carrito (vaciar)
  Future<void> clearCart() async {
    await _cartRepository.clearCart();
    setState(() {
      cartItems.clear();
    });
  }

  // Mostrar un AlertDialog para confirmar si desea eliminar todos los artículos
void _showClearCartDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          '¿Eliminar todos los artículos?',
          style: TextStyle(
            color: Color(0xFFFF7000), // Un color similar al que usas en botones
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Contenido del diálogo
        content: const Text(
          'Se eliminaran todos los artículos de tu carrito',
          style: TextStyle(fontSize: 16),
        ),
        // Botones
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Color(0xFFFF7000), // Color del texto que armoniza con la interfaz
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              clearCart(); // Vaciar el carrito
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text(
              'Eliminar todo',
              style: TextStyle(
                color: Color(0xFFFF7000), // Color para el botón "Eliminar todo"
              ),
            ),
          ),
        ],
        // Personalización del fondo y bordes del AlertDialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Bordes redondeados
        ),
        backgroundColor: Colors.white, // Fondo blanco
        elevation: 5, // Sombra para darle más profundidad
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          GestureDetector(
            onTap: _showClearCartDialog,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${cartItems.length} artículos',
                style: const TextStyle(color: Color(0xFFFF7000)),
              ),
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
              onRemoveItem: removeItem,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ProductSummary(totalAmount: totalAmount),
                const SummaryRow(label: 'Tarifa de envío', amount: '\$50'),
                const Divider(),
                SummaryRow(
                  label: 'Total',
                  amount: '\$${(totalAmount + 50).toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
               // Procesar la orden
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
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Aquí puedes manejar el cambio de navegación si es necesario
        },
      ),
    );
  }
}
