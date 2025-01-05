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
    //print("empieza factory");
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
        paymentMethod: (json['paymentMethod'] as List<dynamic>?)
          ?.map((item) => OrderPayment(
                id: item['id'] as String,
                paymentMethod: item['paymentMethod'] ?? '', // Use default if not available
                currency: item['currency'] ?? '',         // Use de fault if not available
                total: item['total'] ?? 0,                // Use default if not available
              ))
          .toList() ?? [], // Handle missing data gracefully

        report: (json['report'] as List<dynamic>?)
          ?.map((item) => OrderReport(
                id: item['_id'] as String,
                description: item['description'] ?? '',  // Use default if not available
                reportDate: json['reportDate'] != null 
                  ? DateTime.parse(json['reportDate'] as String) 
                  : DateTime.now(),              
              ))
          .toList() ?? [], // Handle missing data gracefully
        );
        
    /*
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
    */
    return order;
  }

  // Serialización del objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate.toIso8601String(),
      'receivedDate': receivedDate,
      'status': status,
      'address': address,
      'products': products.map((product)=>product.toJson()).toList(),
      'combos': combos.map((combo)=>combo.toJson()).toList(),
      'paymentMethod': paymentMethod?.map((payment) => {
        'id': payment.id,
        'paymentMethod': payment.paymentMethod,
        'currency': payment.currency,
        'total': payment.total
      }).toList(),
      'report': report?.map((reportItem) => {
        '_id': reportItem.id,
        'description': reportItem.description,
        'reportDate': reportItem.reportDate.toIso8601String()
      }).toList(),
    };
  }

}