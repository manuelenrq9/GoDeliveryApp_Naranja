import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';

class Order{
  final String id;
  final DateTime createdDate;
  final String status;
  final String address;
  final List<Product> products;
  final List<Combo> combos;
  final DateTime receivedDate;
  final String paymentMethod;
  final String report;

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
        products: List<Product>.from(json['product'] ?? []),
        combos: List<Combo>.from(json['combo'] ?? []),
        receivedDate: json['receivedDate'] as DateTime,
        paymentMethod: json['paymentMethod'] as String,
        report: json['report'] as String,
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