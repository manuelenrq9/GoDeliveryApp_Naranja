import 'package:flutter/material.dart';
import 'cart_item.dart';
import '../../domain/cart_item_data.dart';

class CartItemsList extends StatelessWidget {
  final List<CartItemData> cartItems;
  final Function(int) onIncreaseQuantity;
  final Function(int) onDecreaseQuantity;

  const CartItemsList({
    super.key,
    required this.cartItems,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return CartItem(
          data: cartItems[index],
          onIncrease: () => onIncreaseQuantity(index),
          onDecrease: () => onDecreaseQuantity(index),
        );
      },
    );
  }
}
