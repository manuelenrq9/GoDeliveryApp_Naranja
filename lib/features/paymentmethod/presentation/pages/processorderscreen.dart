import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
import 'package:godeliveryapp_naranja/features/order/data/post_order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/paymentmethod/presentation/pages/CreditDebitScreen.dart';
import 'package:godeliveryapp_naranja/features/paymentmethod/presentation/pages/MobilePaymentScreen.dart';
import 'package:godeliveryapp_naranja/features/paymentmethod/presentation/pages/ZellementScreen.dart';
import 'package:godeliveryapp_naranja/features/paymentmethod/presentation/widgets/PaymentMethodCard.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/domain/cart_item_data.dart';

class ProcessOrderScreen extends StatefulWidget {
  final List<CartItemData> cartItems;
  final List<CartProduct> products; // Lista de productos
  final List<CartCombo> combos; // Lista de combos
  final String currency; // Moneda
  final num totalDecimal; // Total del pedido
  final String userId; // ID del usuario
  final BuildContext context; // Contexto para posibles navegaciones

  const ProcessOrderScreen({
    Key? key,
    required this.cartItems,
    required this.products,
    required this.combos,
    required this.currency,
    required this.totalDecimal,
    required this.userId,
    required this.context,
  }) : super(key: key);

  @override
  _ProcessOrderScreenState createState() => _ProcessOrderScreenState();
}

class _ProcessOrderScreenState extends State<ProcessOrderScreen> {
  bool _isProcessing = false;
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedPaymentMethod;

  void _confirmOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona un método de pago.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simula el procesamiento
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });
    await processOrder(
      address: _addressController.text,
      products: widget.products,
      combos: widget.combos,
      paymentMethod: _selectedPaymentMethod,
      currency: widget.currency,
      totalDecimal: widget.totalDecimal.toInt(),
      userId: widget.userId,
      context: context,
    );
  }

  void _selectPaymentMethod(String method, Widget nextPage) async {
  setState(() {
    _selectedPaymentMethod = method;
  });

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => nextPage,
    ),
  );

  if (result == true) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pago confirmado con $method.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final converter = CurrencyConverter();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Procesar Orden',
            style: TextStyle(
              color: Color.fromARGB(255, 175, 91, 7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 175, 91, 7),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen del Pedido
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumen del Pedido',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 175, 91, 7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Mostrar elementos del carrito
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.cartItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                // Imagen del producto
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Detalles del producto
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'Cantidad: ${item.quantity}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                // Precio
                                Text(
                                  '${converter.selectedCurrency} ${converter.convert(item.price.toDouble()).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total: ${converter.selectedCurrency} ${converter.convert( widget.totalDecimal.toDouble()).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Campo de dirección
              const Text(
                'Ingresa tu Dirección',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 175, 91, 7),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Dirección',
                  hintText: 'Ingresa tu dirección aquí',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una dirección válida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Selección de método de pago
              const Text(
                'Selecciona un Método de Pago',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 175, 91, 7),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  PaymentMethodCard(
                    icon: Icons.credit_card,
                    title: 'Tarjeta de Crédito/Débito',
                    description: 'Paga con tu tarjeta de manera segura.',
                    onTap: () {
                      setState(() {
                        _selectPaymentMethod(
                        'Credit/Debit Card',
                        CreditDebitScreen(),
                      );
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  PaymentMethodCard(
                    icon: Icons.phone_android,
                    title: 'Pago Móvil',
                    description: 'Realiza el pago a través de tu dispositivo móvil.',
                    onTap: () {
                      setState(() {
                        _selectPaymentMethod(
                        'Pago Movil',
                        MobilePaymentScreen(),
                      );
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  PaymentMethodCard(
                    icon: Icons.attach_money,
                    title: 'Zelle',
                    description: 'Paga con Zelle de manera segura y eficiente.',
                    onTap: () {
                      setState(() {
                        _selectPaymentMethod(
                        'Transferencia Zelle',
                        PagoConZelleScreen(),
                      );
                        // _selectedPaymentMethod = 'Zelle';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7000),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isProcessing ? null : _confirmOrder,
                      child: _isProcessing
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Confirmar Orden',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF7000)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 175, 91, 7)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
