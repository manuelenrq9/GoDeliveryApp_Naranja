class CartItemData {
  final String imageUrl;
  final String name;
  final String presentation;
  final double price;

  int quantity;

  CartItemData({
    required this.imageUrl,
    required this.name,
    required this.presentation,
    required this.price,
    this.quantity = 1,
  });
}
