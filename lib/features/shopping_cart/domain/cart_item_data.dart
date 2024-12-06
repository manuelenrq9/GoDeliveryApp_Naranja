class CartItemData {
  final String id;
  final String name;
  final String imageUrl;
  final String presentation;
  final num price;
  int quantity;
  final bool isCombo;
  final String? discount;
  final String currency;

  CartItemData(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.presentation,
      required this.price,
      this.quantity = 1,
      this.isCombo = false,
      required this.discount,
      required this.currency});

  bool isEqual(CartItemData other) {
    return name == other.name && presentation == other.presentation;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'presentation': presentation,
      'price': price,
      'quantity': quantity,
      'isCombo': isCombo,
      'discount': discount,
      'currency': currency,
    };
  }

  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
        id: json['id'] as String,
        name: json['name'],
        imageUrl: json['imageUrl'],
        presentation: json['presentation'],
        price: json['price'],
        quantity: json['quantity'],
        isCombo: json['isCombo'] ?? false,
        discount: json['discount'],
        currency: json['currency']);
  }
}
