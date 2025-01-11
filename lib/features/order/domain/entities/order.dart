import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderPayment.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderReport.dart';

class Order {
  final String id;
  final DateTime createdDate;
  final String status;
  final String address;
  final double latitude;
  final double longitude;
  final List<CartProduct> products;
  final List<CartCombo> combos;
  final DateTime receivedDate;
  final List<OrderPayment> paymentMethod;
  final List<OrderReport> report;
  final DateTime cancelledDate;
  final DateTime shippedDate;
  final DateTime beignProcessedDate;

  const Order({
    required this.id,
    required this.createdDate,
    required this.status,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.products,
    required this.combos,
    required this.receivedDate,
    required this.paymentMethod,
    required this.report,
    required this.cancelledDate,
    required this.shippedDate,
    required this.beignProcessedDate
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    try {
      return Order(
        id: json['id'] ?? '',
        createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : DateTime.now(),
        status: json['status'] ?? 'UNKNOWN',
        address: json['address'] ?? 'Sin dirección',
        latitude: json['latitude'] ?? 0.0,
        longitude: json['longitude'] ?? 0.0,
        receivedDate: DateTime.parse(json['receivedDate']),
        products: (json['products'] as List<dynamic>?)?.map((item) => CartProduct.fromJson(item)).toList() ?? [],
        combos: (json['combos'] as List<dynamic>?)?.map((item) => CartCombo.fromJson(item)).toList() ?? [],
        // products: (json['products'] as List<dynamic>)
        //     .map((item) => CartProduct.fromJson(item))
        //     .toList(),
        // combos: (json['combos'] as List<dynamic>)
        //     .map((item) => CartCombo.fromJson(item))
        //     .toList(),
        paymentMethod: json['paymentMethod'] != null
            ? [OrderPayment.fromJson(json['paymentMethod'])]
            : [],
        report: json['report'] != null
            ? [OrderReport.fromJson(json['report'])]
            : [],
        cancelledDate: json['cancelledDate'] != null ? DateTime.parse(json['cancelledDate']) : DateTime.now(),
        shippedDate: json['shippedDate'] != null ? DateTime.parse(json['shippedDate']) : DateTime.now(),
        beignProcessedDate: json['beignProcessedDate'] != null ? DateTime.parse(json['beignProcessedDate']) : DateTime.now(),
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
      'latitude': latitude,
      'longitude': longitude,
      'receivedDate': receivedDate.toIso8601String(),
      'products': products.map((product) => product.toJson()).toList(),
      'combos': combos.map((combo) => combo.toJson()).toList(),
      'paymentMethod':
          paymentMethod.isNotEmpty ? paymentMethod.first.toJson() : null,
      'report': report.isNotEmpty ? report.first.toJson() : null,
      'cancelledDate': cancelledDate.toIso8601String(),
      'shippedDate': shippedDate.toIso8601String(),
      'beignProcessedDate': beignProcessedDate.toIso8601String(),
    };
  }
}
