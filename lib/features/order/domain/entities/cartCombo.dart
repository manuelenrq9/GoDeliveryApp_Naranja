class CartCombo {
  final String id;
  final int quantity;

  CartCombo({required this.id, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'quantity': quantity,
    };
  }
}