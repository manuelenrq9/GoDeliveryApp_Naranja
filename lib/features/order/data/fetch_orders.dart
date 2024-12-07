import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/order_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {

  late Future<List<Order>> futureOrders;

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Obtén el token almacenado
  }

  late final DataService<Order> _orderService = DataService<Order>(
      endpoint: '/order',
      repository: GenericRepository<Order>(
        storageKey: 'orders',
        fromJson: (json) => Order.fromJson(json),
        toJson: (order) => order.toJson(),
      ),
      fromJson: (json) => Order.fromJson(json),
    );

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() async {
    futureOrders = _orderService.loadData();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: futureOrders,
      builder: (context, snapshot) {
        print(snapshot.hasData);
        if (snapshot.hasData){
          // Extract the data from the snapshot only once
          final orders = snapshot.data!;

          // Filter orders based on status within the builder
          final deliveredOrders = orders.where((order) => order.status == 'BEING PROCESSED').toList();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: deliveredOrders.map((order) => OrderCard(order: order)).toList(),
          );
        } else if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator(color: Colors.orange,));
      }
    );
  }
}