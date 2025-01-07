import 'package:godeliveryapp_naranja/features/order/data/orders_repository.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';

class FetchOrdersUsecase {
  OrdersRepository repository = OrdersRepository();

  fetchOrders(){
    Future<List<Order>> futureOrders = repository.getOrders();
    return futureOrders; 
  }
  
}


