// class CartProduct {
//   final String id;
//   final int quantity;

//   CartProduct({required this.id, required this.quantity});
// }

class CartProduct {
  final String id;
  final int quantity;

  CartProduct({
    required this.id,
    required this.quantity,
  });

  // Método fromJson añadido para deserialización
  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  // Método toJson añadido para serialización
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }
}
