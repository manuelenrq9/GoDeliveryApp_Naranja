import 'dart:async';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';

class OrdersRepository {
  late Future<List<Order>> futureOrders;
  late final DataService<Order> _orderService = DataService<Order>(
    endpoint: '/order?take=30',
    repository: GenericRepository<Order>(
      storageKey: 'orders',
      fromJson: (json) => Order.fromJson(json),
      toJson: (order) => order.toJson(),
    ),
    fromJson: (json) => Order.fromJson(json),
  );

  void loadOrders() async {
    futureOrders = _orderService.loadData();
  }

  Future<List<Order>> getOrders() async{
    loadOrders();
    return futureOrders;
  }
}

