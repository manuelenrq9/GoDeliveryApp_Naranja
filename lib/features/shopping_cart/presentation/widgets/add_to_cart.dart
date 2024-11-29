import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/card_repository.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/domain/cart_item_data.dart';

class AddToCartLogic {
  final CartRepository cartRepository = CartRepository();

  // Agregar producto o combo al carrito
  Future<void> addToCart({
    Product? product,
    Combo? combo,
    required int quantity,
    required num price,
    required Function resetQuantity,
    required void Function(String message) showSnackBar,
  }) async {

    // Lógica para añadir al carrito
    if (product != null) {
      // Si es un producto, crea el CartItemData correspondiente
      final cartItem = CartItemData(
        id: product.id,
        name: product.name,
        imageUrl: product.image,
        presentation: "${product.weight} gr",
        price: price,
        quantity: quantity,
        isCombo: false,
      );

      // Añadir el producto al carrito
      await cartRepository.addItem(cartItem);
    } else if (combo != null) {
      // Si es un combo, crea el CartItemData correspondiente
      final cartItem = CartItemData(
        id: combo.id,
        name: combo.name,
        imageUrl: combo.comboImage,
        presentation: "Combo de ${combo.products.length} productos",
        price: price,
        quantity: quantity,
        isCombo: true,
      );

      // Añadir el combo al carrito
      await cartRepository.addItem(cartItem);
    }

    // Restablecer la cantidad
    resetQuantity();

    // Mostrar un SnackBar confirmando que el item ha sido añadido al carrito
    showSnackBar('Se añadio  al carrito');
  }
}