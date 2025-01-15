import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/widgets/add_to_cart.dart';

class ButtonAddCartMenu extends StatefulWidget {
  final Product? product; // El producto a añadir al carrito (si es un producto)
  final Combo? combo; // El combo a añadir al carrito (si es un combo)

  ButtonAddCartMenu({
    Key? key,
    this.product,
    this.combo,
  })  : assert(
            (product == null && combo != null) ||
                (product != null && combo == null),
            'Debe pasar solo un parámetro: producto o combo'),
        super(key: key);

  @override
  _ButtonAddCartMenuState createState() => _ButtonAddCartMenuState();
}

class _ButtonAddCartMenuState extends State<ButtonAddCartMenu> {
  bool _isExpanded = false; // Estado para saber si el botón está expandido
  int _quantity = 0; // Cantidad del producto o combo
  Timer?
      _debounceTimer; // Timer para esperar 2 segundos después de dejar de presionar
  bool _isAddingToCart = false; // Estado para saber si ya se añadió al carrito

  // Lógica para agregar al carrito usando AddToCartLogic
  Future<void> _sendToCart() async {
    if (_quantity > 0) {
      setState(() {
        _isAddingToCart = true;
      });

      // Instancia de la lógica de añadir al carrito
      final addToCartLogic = AddToCartLogic();

      // Usar la lógica de AddToCartLogic para añadir al carrito
      await addToCartLogic.addToCart(
        product: widget.product,
        combo: widget.combo,
        quantity: _quantity,
        price: (widget.product?.price ?? widget.combo?.specialPrice ?? 0),
        resetQuantity: _resetQuantity,
        showSnackBar: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  if (widget.product != null &&
                      widget.product!.image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        widget.product!.image.first,
                        width: 48,
                        height: 48,
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
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
            ),
          );
        },
      );

      setState(() {
        _isAddingToCart = false;
        _isExpanded = false;
      });
    }
  }

  // Función para resetear la cantidad
  void _resetQuantity() {
    setState(() {
      _quantity = 0;
    });
  }

  // Función para manejar la cantidad
  void _updateQuantity(int delta) {
    setState(() {
      _quantity += delta;
      if (_quantity < 0) {
        _quantity = 0; // Evitar cantidades negativas
      }
    });

    // Cancelar cualquier timer anterior
    _debounceTimer?.cancel();

    // Esperar 2 segundos después de la última acción para enviar al carrito
    _debounceTimer = Timer(Duration(seconds: 2), () {
      if (_quantity > 0) {
        _sendToCart();
      } else {
        _expandAndReset();
      }
    });
  }

  // Función para expandir y contraer el botón de manera automática
  void _expandAndReset() {
    setState(() {
      _isExpanded = true;
    });

    // Iniciar un temporizador para que vuelva al estado original después de 2 segundos
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(seconds: 2), () {
      _sendToCart();
      setState(() {
        if (_quantity > 0) {
          _sendToCart();
        } else {
          setState(() {
            _isExpanded =
                false; // Contraer el botón después de 2 segundos si la cantidad es 0
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isAddingToCart) {
          _expandAndReset();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 30,
        width: _isExpanded ? 100 : 30,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 168, 62, 0)
              : const Color(0xFFFF9027),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isExpanded && !_isAddingToCart) ...[
              Container(
                height: 30,
                child: OverflowBox(
                  maxWidth: double
                      .infinity, // Permite que el contenido sobrepase el ancho del contenedor
                  maxHeight: double
                      .infinity, // Permite que el contenido sobrepase el alto del contenedor
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.white),
                        onPressed: () => _updateQuantity(-1),
                      ),
                      Text(
                        '$_quantity',
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () => _updateQuantity(1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (!_isExpanded || _isAddingToCart)
              Icon(
                Icons.add,
                color: Colors.white,
                size: 15,
              ),
          ],
        ),
      ),
    );
  }
}
