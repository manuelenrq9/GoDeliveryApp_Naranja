// class CartCombo {
//   final String id;
//   final int quantity;

//   CartCombo({required this.id, required this.quantity});
// }

class CartCombo {
  final String id;
  final int quantity;

  CartCombo({
    required this.id,
    required this.quantity,
  });

  // Método fromJson añadido para deserialización
  factory CartCombo.fromJson(Map<String, dynamic> json) {
    return CartCombo(
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