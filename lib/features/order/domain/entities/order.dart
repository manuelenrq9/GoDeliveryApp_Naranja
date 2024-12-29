import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderPayment.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderReport.dart';

class Order{
  final String id;
  final DateTime createdDate;
  final DateTime receivedDate;
  final String status;
  final String address;
  final List<CartProduct> products;
  final List<CartCombo> combos;
  final List<OrderPayment>? paymentMethod;
  final List<OrderReport>? report;

  const Order({
    required this.id,
    required this.createdDate,
    required this.receivedDate,
    required this.status,
    required this.address,
    required this.products,
    required this.combos,
    this.paymentMethod,
    this.report,
  });

// Deserialización del JSON
factory Order.fromJson(Map<String, dynamic> json) {
    print("empieza factory");
    var order = Order(
        id: json['id'] as String,
        createdDate: DateTime.parse(json['createdDate'] as String),
        receivedDate: DateTime.parse(json['receivedDate'] as String),
        status: json['status'] as String,
        address: json['address'] as String,
        products: (json['products'] as List<dynamic>?)
            ?.map((item) => CartProduct(
                id: item['id'] as String,
                quantity: item['quantity'] as int,
            ))
            .toList() ?? [],
        combos: (json['combos'] as List<dynamic>?)
            ?.map((item) => CartCombo(
                id: item['id'] as String,
                quantity: item['quantity'] as int,
            ))
            .toList() ?? [],
        );
    var products = order.products;
    products.forEach((product){
      print(product.id);
      print(product.quantity);
    });
    var combos = order.combos;
    combos.forEach((combo){
      print(combo.id);
      print(combo.quantity);
    });
    print(order.status);
    print("termina factory");
    print("");
    print("");
    print("");
    print("");
    print("");
    print("");
    return order;
  }

  // Serialización del objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate,
      'status': status,
      'address': address,
      'products': products,
      'combos': combos,
      'receivedDate': receivedDate,
      'paymentMethod': paymentMethod,
      'report': report,
    };
  }

}