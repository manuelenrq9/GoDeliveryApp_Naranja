class OrderPayment {
  final String id;
  final String paymentMethod;
  final String currency;
  final int total;

  OrderPayment({required this.id,required this.paymentMethod,required this.currency, required this.total});
}
