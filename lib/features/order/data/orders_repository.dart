import 'dart:async';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersRepository {
  late Future<List<Order>> futureOrders;
  
    Future<String?> _getApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_url'); // Obtén el token almacenado
  }

  // void loadOrders() async {
  //   final apiUrl = await _getApi();
  //   if(apiUrl=="https://amarillo-backend-production.up.railway.app"){
  //     final DataService<Order> _orderService = DataService<Order>(
  //       endpoint: '/order/many',
  //       repository: GenericRepository<Order>(
  //         storageKey: 'orders',
  //         fromJson: (json) => Order.fromJson(json),
  //         toJson: (order) => order.toJson(),
  //       ),
  //       fromJson: (json) => Order.fromJson(json),
  //     );
  //     futureOrders = _orderService.loadData();
  //   }else{
  //     final DataService<Order> _orderService2 = DataService<Order>(
  //       endpoint: '/order/many',
  //       repository: GenericRepository<Order>(
  //         storageKey: 'orders',
  //         fromJson: (json) => Order.fromJson2(json),
  //         toJson: (order) => order.toJson(),
  //       ),
  //       fromJson: (json) => Order.fromJson2(json),
  //     );
  //     futureOrders = _orderService2.loadData();
  //   }
  // }

  // Future<List<Order>> getOrders() async{
  //   loadOrders();
  //   return futureOrders;
  // }
   // Método para cargar las órdenes
  Future<void> loadOrders() async {
    final apiUrl = await _getApi();
    if (apiUrl == "https://amarillo-backend-production.up.railway.app") {
      final DataService<Order> _orderService = DataService<Order>(
        endpoint: '/order/many?status=SHIPPED&status=BEING%20PROCESSED&status=CREATED&status=DELIVERED&status=CANCELLED&perpage=60&page=1',
        repository: GenericRepository<Order>(
          storageKey: 'orders',
          fromJson: (json) => Order.fromJson2(json),
          toJson: (order) => order.toJson(),
        ),
        fromJson: (json) => Order.fromJson2(json),
      );
      futureOrders = _orderService.loadData();
    } else {
      final DataService<Order> _orderService2 = DataService<Order>(
        endpoint: '/order/many?take=60',
        repository: GenericRepository<Order>(
          storageKey: 'orders',
          fromJson: (json) => Order.fromJson(json),
          toJson: (order) => order.toJson(),
        ),
        fromJson: (json) => Order.fromJson(json),
      );
      futureOrders = _orderService2.loadData();
    }
  }

  // Método para obtener las órdenes
  Future<List<Order>> getOrders() async {
    await loadOrders();  // Esperamos a que loadOrders termine
    return futureOrders;  // Ahora futureOrders estará inicializado
  }
}
