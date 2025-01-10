import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';
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

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  bool _isAdding = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addToCartLogic =
        AddToCartLogic(); // Instancia de la lógica de añadir al carrito

    return AnimatedScale(
      scale: _isAdding ? _scaleAnimation.value : 1.0,
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: _isAdding
            ? null // Deshabilitar el botón mientras se está añadiendo
            : () async {
                setState(() {
                  _isAdding = true;
                  _controller.forward(); // Iniciar la animación de escala
                });

                // Llamar a la lógica de añadir al carrito
                await addToCartLogic.addToCart(
                  product: widget.product,
                  combo: widget.combo,
                  quantity: widget.quantity,
                  price: (widget.product?.price ??
                      widget.combo?.specialPrice ??
                      0),
                  resetQuantity: widget.resetQuantity,
                  showSnackBar: (message) async {
                    await Future.delayed(const Duration(seconds: 2));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            if (widget.product != null &&
                                widget.product!.image.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  widget.product!.image.first,
                                  width: 58,
                                  height: 58,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else if (widget.combo != null &&
                                widget.combo!.comboImage.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  widget.combo!.comboImage.first,
                                  width: 58,
                                  height: 58,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(width: 48, height: 48),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.product != null ? widget.product!.name : widget.combo!.name} añadido al carrito',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 4),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        action: SnackBarAction(
                          label: 'Ir al carrito',
                          textColor: Colors.white,
                          onPressed: () {
                            // Navegar a la pantalla del carrito
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen()),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );

                await Future.delayed(const Duration(seconds: 2));

                setState(() {
                  _isAdding = false;
                  _controller.reverse(); // Revertir la animación de escala
                });
              },
        child: _isAdding
            ? const Icon(
                Icons.shopping_cart_checkout_sharp,
                color: Colors.black,
                size: 32, // Tamaño más grande del icono
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.shopping_cart, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Añadir al carrito',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isAdding ? Colors.green : const Color(0xFFFF9027),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
