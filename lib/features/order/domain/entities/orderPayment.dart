class OrderPayment {
  final String id;
  final String paymentMethod;
  final String currency;
  final double total;

  OrderPayment({
    required this.id, 
    required this.paymentMethod, 
    required this.currency, 
    required this.total
    });

  factory OrderPayment.fromJson(Map<String, dynamic> json) {
    return OrderPayment(
      id: json['id'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      currency: json['currency'] ?? '',
      total: (json['total'] is num) 
          ? (json['total'] as num).toDouble() 
          : 0.0,
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentMethod': paymentMethod,
      'currency': currency,
      'total': total
    };
  }
}
