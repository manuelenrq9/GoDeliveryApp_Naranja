import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:godeliveryapp_naranja/core/widgets/counterManager.dart';
import 'cart_item.dart';
import '../../domain/cart_item_data.dart';

class CartItemsList extends StatelessWidget {
  final List<CartItemData> cartItems;
  final Function(int) onIncreaseQuantity;
  final Function(int) onDecreaseQuantity;
  final Function(int) onRemoveItem;

  const CartItemsList({
    super.key,
    required this.cartItems,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];

        return Slidable(
          key: ValueKey(item.id), // Identificador único para cada ítem
          endActionPane: ActionPane(
            motion: DrawerMotion(), // Tipo de movimiento (como un cajón)
            extentRatio: 0.25, // Espacio que ocupa el botón (25% del ancho)
            children: [
              SlidableAction(
                onPressed: (context) {
                  // Llamar a la función para eliminar el producto
                  CounterManager().decrement();
                  onRemoveItem(index);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                flex: 1,
                // El botón de eliminar tendrá el mismo estilo que el de la lista de productos
                padding: const EdgeInsets.symmetric(vertical: 10),
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          child: CartItem(
              data: item,
              onIncrease: () => onIncreaseQuantity(index),
              onDecrease: () => onDecreaseQuantity(index),
              onRemove: () => onRemoveItem(index)),
        );
      },
    );
  }
}
