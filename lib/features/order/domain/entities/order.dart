import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderPayment.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderReport.dart';

class Order{
  final String id;
  final DateTime createdDate;
  final String status;
  final String address;
  final List<CartProduct> products;
  final List<CartCombo> combos;
  final DateTime receivedDate;
  final List<OrderPayment> paymentMethod;
  final List<OrderReport> report;

  const Order({
    required this.id,
    required this.createdDate,
    required this.status,
    required this.address,
    required this.products,
    required this.combos,
    required this.receivedDate,
    required this.paymentMethod,
    required this.report
  });

// Deserialización del JSON
factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'] as String,
        createdDate: json['createdDate'] as DateTime,
        status: json['status'] as String,
        address: json['address'] as String,
        products: List<CartProduct>.from(json['products'] ?? []),
        combos: List<CartCombo>.from(json['combos'] ?? []),
        paymentMethod: List<OrderPayment>.from(json['paymentMethod'] ?? []),
        report: List<OrderReport>.from(json['report'] ?? []),
        receivedDate: json['receivedDate'] as DateTime,
        );
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