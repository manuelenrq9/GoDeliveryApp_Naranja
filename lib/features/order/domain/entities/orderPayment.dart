// class OrderPayment {
//   final String id;
//   final String paymentMethod;
//   final String currency;
//   final int total;

//   OrderPayment({required this.id,required this.paymentMethod,required this.currency, required this.total});
// }


class OrderPayment {
  final String id;

  OrderPayment({required this.id});

  factory OrderPayment.fromJson(Map<String, dynamic> json) {
    return OrderPayment(id: json['id'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
