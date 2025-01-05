class CartProduct {
  final String id;
  final int quantity;

  CartProduct({required this.id, required this.quantity});

  // Serialización del objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'quantity': quantity,
    };
  }
}