import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/product/domain/product.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/widgets/add_to_cart.dart';

class AddToCartButton extends StatefulWidget {
  final Product? product;
  final Combo? combo;
  final int quantity;
  final num price;
  final Function resetQuantity;

  const AddToCartButton({
    Key? key,
    this.product,
    this.combo,
    required this.quantity,
    required this.price,
    required this.resetQuantity,
  }) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
} 

class _AddToCartButtonState extends State<AddToCartButton> {
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    final addToCartLogic = AddToCartLogic(); // Instancia de la lógica de añadir al carrito

    return ElevatedButton.icon(
      onPressed: _isAdding
          ? () {} // No hacer nada si está bloqueado, pero sin deshabilitar el botón
          : () async {
            setState(() {
                _isAdding = true; // Bloquear el botón durante 2 segundos
              });
        // Llamar a la lógica de añadir al carrito
        await addToCartLogic.addToCart(
          product: widget.product,
          combo: widget.combo,
          quantity: widget.quantity,
          price: (widget.product?.price ?? widget.combo?.specialPrice ?? 0),
          resetQuantity: widget.resetQuantity,
          showSnackBar: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('${widget.product?.name ?? widget.combo?.name} añadido al carrito'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
            );
          },
        );
        await Future.delayed(Duration(seconds: 2));

        setState(() {
        _isAdding = false; // Rehabilitar el botón después de 2 segundos
        });
      },
      icon: const Icon(Icons.shopping_cart, color: Colors.white),
      label: const Text(
        'Añadir al carrito',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF9027),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(fontSize: 18),
      ),
    );
  }
}
