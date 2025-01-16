// custom_drawer.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/core/widgets/counterManager.dart';
import 'package:godeliveryapp_naranja/features/category/data/categoryScreen.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/login.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/pages/order_history_screen.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/OrderSummaryScreen.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  User? _cachedUser;
  bool _isDataLoaded = false; 

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedUserData = prefs.getString('cached_user_data');
    if (cachedUserData != null) {
      setState(() {
        _cachedUser = User.fromJson(json.decode(cachedUserData));
        _isDataLoaded = true;
      });
    }
  }

  Future<User?> _getUserData() async {
    if (_isDataLoaded && _cachedUser != null) {
      // Si los datos ya están cargados, retorna el usuario almacenado
      return _cachedUser;
    }

    String? userID = await _getUserID();

    if (userID == null) {
      return null;
    }

    final apiUrl = await _getApi();
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No hay token de autenticación');

      String url = apiUrl ==
              "https://orangeteam-deliverybackend-production.up.railway.app"
          ? '$apiUrl/user/one/$userID'
          : '$apiUrl/user/$userID';

      final response = await http.get(
        Uri.parse('$url'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final user = User.fromJson(data);

        // Almacena el usuario cargado en caché
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('cached_user_data', json.encode(data));

        setState(() {
          _cachedUser = user;
          _isDataLoaded = true;
        });

        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
  
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> _getApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_url'); // Obtén el token almacenado
  }

  Future<String?> _getUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('user_id');
  }


  Widget _buildCartIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(0.0),
          child: Icon(
            Icons.shopping_cart,
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<User?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Error al cargar los datos del usuario.'));
          }

          final User user = snapshot.data!;

          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  user.email,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(user.profileImageUrl),
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7000), // Fondo de color naranja
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
                  showLoadingScreen(context, destination: const OrderHistoryScreen());
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
          );
        },
      ),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['image'] ??
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
    );
  }
}