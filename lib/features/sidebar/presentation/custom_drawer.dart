// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/core/widgets/counterManager.dart';
import 'package:godeliveryapp_naranja/features/category/data/categoryScreen.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/login.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/pages/order_history_screen.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/OrderSummaryScreen.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
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
            color: Colors.grey,
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text(
              'maria_silva23',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              'maria.silva23@gmail.com',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                  'https://pymstatic.com/5844/conversions/personas-emocionales-wide_webp.webp'),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7000), // Fondo de color naranja
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              showLoadingScreen(context, destination: const MainMenu());
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial de pedidos'),
            onTap: () {
              showLoadingScreen(context,
                  destination: const OrderHistoryScreen());
              // Acción para ir al historial de pedidos
            },
          ),
          ListTile(
            leading: _buildCartIcon(),
            title: const Text('Carrito'),
            onTap: () {
              showLoadingScreen(context, destination: const CartScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Detalle de orden'),
            onTap: () {
              showLoadingScreen(context, destination: OrderHistoryScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categoria'),
            onTap: () {
              showLoadingScreen(context, destination: const CategoryScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar sesión'),
            onTap: () {
              showLoadingScreen(context, destination: const LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}
