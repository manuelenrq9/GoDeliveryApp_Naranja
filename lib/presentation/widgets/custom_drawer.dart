// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/carrito/cart_screen.dart';
import 'package:godeliveryapp_naranja/orderhistory/order_history_screen.dart';
import 'package:godeliveryapp_naranja/ordersummary/OrderSummaryScreen.dart';
import 'package:godeliveryapp_naranja/presentation/interfaces/loading_screen.dart';
import 'package:godeliveryapp_naranja/presentation/interfaces/login.dart';
import 'package:godeliveryapp_naranja/presentation/interfaces/main_menu.dart';

class CustomDrawer extends StatelessWidget {
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
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Carrito'),
            onTap: () {
              showLoadingScreen(context, destination: const CartScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Detalle de orden'),
            onTap: () {
              showLoadingScreen(context, destination: OrderSummaryScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categoria'),
            onTap: () {},
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
