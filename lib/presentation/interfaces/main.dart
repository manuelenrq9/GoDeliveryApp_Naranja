import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/carrito/cart_screen.dart';
import 'package:godeliveryapp_naranja/detallecombo.dart';
import 'package:godeliveryapp_naranja/orderhistory/order_history_screen.dart';
import 'package:godeliveryapp_naranja/ordersummary/OrderSummaryScreen.dart';
import 'package:godeliveryapp_naranja/product_detail.dart';
import 'main_menu.dart';
import 'package:godeliveryapp_naranja/presentation/interfaces/register.dart';
import 'package:godeliveryapp_naranja/presentation/interfaces/login.dart';
import 'main_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainMenu()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
