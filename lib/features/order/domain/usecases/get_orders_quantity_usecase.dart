import 'package:godeliveryapp_naranja/features/order/data/orders_repository.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';

class GetOrdersQuantityUsecase{
  OrdersRepository repository = OrdersRepository();
  late List<Order> orders;
  late num quantity;

  Future<void> fetchOrders() async{
    orders = await repository.getOrders();
  }

  Future<num> getActiveOrdersQuantity() async{
    await fetchOrders();
    List<Order> activeOrders = orders.where((order){
      return order.status == 'BEING PROCESSED' || order.status == 'SHIPPED';
    }).toList();
    num activeOrdersQuantity = activeOrders.length;
    print("CANTIDAD DE ORDENES ACTIVAS");
    print(activeOrdersQuantity);
    return activeOrdersQuantity;
  }

  Future<num> getOrdersQuantity() async{
    await fetchOrders();
    quantity = orders.length;
    return quantity;
  }
}