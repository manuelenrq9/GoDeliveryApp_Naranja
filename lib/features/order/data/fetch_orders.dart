import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/order_card.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {

  late Future<List<Order>> futureOrders;

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
        if (snapshot.hasData){
          if(snapshot.data!.isEmpty){
            return const Center(child: Text('No hay órdenes disponibles.'));
          }
          else{
            return Wrap(
                children: snapshot.data!.map((order) => OrderCard(order: order)).toList(),
            );
          }
        } else if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator(color: Colors.orange,));
      }
    );
  }
}