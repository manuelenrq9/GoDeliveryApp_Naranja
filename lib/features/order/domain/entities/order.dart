import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderPayment.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderReport.dart';

class Order {
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
    required this.report,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    try {
      return Order(
        id: json['id'] ?? '',
        createdDate: DateTime.parse(json['createdDate']),
        status: json['status'] ?? 'UNKNOWN',
        address: json['address'] ?? 'Sin dirección',
        receivedDate: DateTime.parse(json['receivedDate']),
        
        // Conversión correcta de productos y combos
        products: (json['products'] as List<dynamic>)
            .map((item) => CartProduct.fromJson(item))
            .toList(),
        combos: (json['combos'] as List<dynamic>)
            .map((item) => CartCombo.fromJson(item))
            .toList(),

        // ✅ Conversión corregida para objetos individuales
        paymentMethod: json['paymentMethod'] != null
            ? [OrderPayment.fromJson(json['paymentMethod'])]
            : [],
        report: json['report'] != null
            ? [OrderReport.fromJson(json['report'])]
            : [],
      );
    } catch (e) {
      print("Error al deserializar Order: $e");
      throw Exception("Error al procesar el JSON de Order");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate.toIso8601String(),
      'status': status,
      'address': address,
      'receivedDate': receivedDate.toIso8601String(),
      'products': products.map((product) => product.toJson()).toList(),
      'combos': combos.map((combo) => combo.toJson()).toList(),
      'paymentMethod': paymentMethod.isNotEmpty 
          ? paymentMethod.first.toJson()
          : null,
      'report': report.isNotEmpty 
          ? report.first.toJson()
          : null,
    };
  }
}
