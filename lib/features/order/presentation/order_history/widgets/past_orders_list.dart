import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/usecases/fetch_orders_usecase.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/order_card.dart';

class PastOrdersScreen extends StatefulWidget {
  const PastOrdersScreen({super.key});

  @override
  State<PastOrdersScreen> createState() => _PastOrdersScreenState();
}

class _PastOrdersScreenState extends State<PastOrdersScreen> {
  late Future<List<Order>> futureOrders;
  FetchOrdersUsecase usecase = FetchOrdersUsecase();

  void loadOrders() async {
    futureOrders = usecase.fetchOrders();
  }

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(

        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print("Tiene data ${snapshot} y el otro ${context}");
            // print("DATA ${snapshot.data}");
            // Extract the data from the snapshot only once
            final orders = snapshot.data!;

            // Filter orders based on status within the builder
            final deliveredOrders = orders
                .where((order) => order.status == 'DELIVERED' || 
                  order.status == 'CANCELLED'
                )
                .toList();
            // print("AQUI SON LAS ORDENES ORDER ${deliveredOrders}");
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: deliveredOrders
                  .map((order) => OrderCard(order: order))
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.orange,
          ));
        });
  }
}
