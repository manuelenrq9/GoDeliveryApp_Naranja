import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/domain/cart_item_data.dart';

class CartRepository extends GenericRepository<CartItemData> {
  CartRepository()
      : super(
          storageKey: 'cart_items',
          fromJson: (json) => CartItemData.fromJson(json),
          toJson: (item) => item.toJson(),
        );

  // Métodos adicionales para manejar el carrito
  Future<void> addItem(CartItemData item) async {
    final items = await loadData();
    final index = items.indexWhere((existing) => existing.isEqual(item));
    if (index != -1) {
      items[index].quantity += item.quantity;
    } else {
      items.add(item);
    }
    await saveData(items);
  }

  Future<void> updateItem(CartItemData item) async {
    final items = await loadData();
    final index = items.indexWhere((existing) => existing.isEqual(item));
    if (index != -1) {
      items[index] = item;
      await saveData(items);
    }
  }

  Future<void> removeItem(CartItemData item) async {
    final items = await loadData();
    items.removeWhere((existing) => existing.isEqual(item));
    await saveData(items);
  }

  Future<void> clearCart() async {
    await saveData([]);
  }
}
