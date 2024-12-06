import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/usecases/create_order.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/card_repository.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/widgets/summary_row.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import '../../domain/cart_item_data.dart';
import '../widgets/cart_items_list.dart';
import '../widgets/summary_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartRepository _cartRepository;
  List<CartItemData> cartItems = [];
  List<Product> products = [];
  List<Combo> combos = [];
  ProcessOrder orderProcessor = ProcessOrder();

  @override
  void initState() {
    super.initState();
    _cartRepository = CartRepository();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await _cartRepository.loadData();
    setState(() {
      cartItems = items;
    });
  }

  Future<void> _updateCart() async {
    await _cartRepository.saveData(cartItems);
  }

  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
    _updateCart();
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
    _updateCart();
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
    _updateCart();
    }

    void getProducts(){
      void getProducts() {
          products = cartItems.map((cartItem) => Product(
              id: cartItem.id,
              name: cartItem.name,
              // Handle missing description (consider default value or logic)
              description:'', // Might not be ideal description
              image: [], // Assuming no image information in CartItemData
              price: cartItem.price,
              currency: cartItem.currency,
              // Handle missing weight, stock, category, measurement, caducityDate, discount
              weight: 0.0, // Set default value or handle based on your needs
              stock: 0,
              category: [],
              measurement: "",
              caducityDate: DateTime.now(),
              discount: cartItem.discount,
          )).toList();
      }
  }

  void getCombos(){
    combos = cartItems.map((cartItem) => Combo(
              id: cartItem.id,
              name: cartItem.name,
              specialPrice: 0,
              currency: cartItem.currency,
              description: '',
              weight: 0.0, // Set default value or handle based on your needs
              stock: 0,
              category: [],
              measurement: "",
              caducityDate: DateTime.now(),
              discount: cartItem.discount,
          )).toList();
  }

  Order createOrder(String address,List<Product> products ,List<Combo> combos ,String paymentMethod){
    Order order = orderProcessor.createOrder(address, products, combos, paymentMethod);
    return order;
  }

  Future<void> clearCart() async {
    await _cartRepository.clearCart();
    setState(() {
      cartItems.clear();
    });
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '¿Eliminar todos los artículos?',
            style: TextStyle(
              color: Color(0xFFFF7000),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Se eliminaran todos los artículos de tu carrito',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Color(0xFFFF7000),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                clearCart();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Eliminar todo',
                style: TextStyle(
                  color: Color(0xFFFF7000),
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          elevation: 5,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrito',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 175, 91, 7),
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: _showClearCartDialog,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Icon(
                Icons.delete_outline,
                color: Color(0xFFFF7000),
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Color.fromARGB(
              255, 175, 91, 7), // Set the color of the back icon here
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainMenu()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Lista de productos
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined,
                            size: 60, color: Color(0xFFFF7000)),
                        const Text(
                          "Tu carrito está vacío.",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 175, 91, 7)),
                        ),
                        const Text(
                          "¡Explora nuestros productos te esperamos !",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 175, 91, 7)),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainMenu()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Explorar productos',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : CartItemsList(
                    cartItems: cartItems,
                    onIncreaseQuantity: increaseQuantity,
                    onDecreaseQuantity: decreaseQuantity,
                    onRemoveItem: removeItem,
                  ),
          ),
          // Resumen del carrito
          if (cartItems.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(248, 177, 175, 173).withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: cartItems.isEmpty
                        ? null
                        : () {
                            getProducts();
                            getCombos();
                            createOrder('Caracas', products, combos, paymentMethod)
                            // Procesar la orden
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Procesar Orden',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 2,
        onTap: (index) {},
      ),
    );
  }
}
