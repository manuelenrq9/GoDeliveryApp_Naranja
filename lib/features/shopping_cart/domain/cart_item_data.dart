class CartItemData {
  final String name;
  final String imageUrl;
  final String presentation;
  final num price;
  int quantity;

  CartItemData({
    required this.name,
    required this.imageUrl,
    required this.presentation,
    required this.price,
    this.quantity = 1,
  });

  bool isEqual(CartItemData other) {
    return name == other.name && presentation == other.presentation;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'presentation': presentation,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      name: json['name'],
      imageUrl: json['imageUrl'],
      presentation: json['presentation'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}
