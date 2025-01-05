class OrderPayment {
  final String id;
  final String paymentMethod;
  final String currency;
  final int total;

  OrderPayment({
    required this.id,
    this.paymentMethod = '',
    this.currency = '', 
    this.total = 0
  });
}
