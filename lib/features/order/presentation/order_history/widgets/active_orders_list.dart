import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/usecases/fetch_orders_usecase.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/order_card.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/pages/order_summary.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/OrderSummaryScreen.dart';

class ActiveOrdersScreen extends StatefulWidget {
  const ActiveOrdersScreen({super.key});

  @override
  State<ActiveOrdersScreen> createState() => _ActiveOrdersScreenState();
}

class _ActiveOrdersScreenState extends State<ActiveOrdersScreen> {
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
            // Extract the data from the snapshot only once
            final orders = snapshot.data!;

            // Filter orders based on status within the builder
            final deliveredOrders = orders
                .where((order) =>
                    order.status == 'CREATED' ||
                    order.status == 'BEING PROCESSED' ||
                    order.status == 'SHIPPED')
                .toList();
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: deliveredOrders
                  .map((order) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderSummaryScreen(order: order),
                            ),
                          );
                        },
                        child: OrderCard(order: order),
                      ))
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
