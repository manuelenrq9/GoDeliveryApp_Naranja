import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
import 'package:godeliveryapp_naranja/core/dataID.services.dart';
import 'package:godeliveryapp_naranja/features/cupon/domain/cupon.dart';
import 'package:godeliveryapp_naranja/features/order/data/post_order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/pages/order_direction.dart';
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
  num totalDecimal; // Total del pedido
  final BuildContext context; // Contexto para posibles navegaciones

  ProcessOrderScreen({
    Key? key,
    required this.cartItems,
    required this.products,
    required this.combos,
    required this.currency,
    required this.totalDecimal,
    required this.context,
  }) : super(key: key);

  @override
  _ProcessOrderScreenState createState() => _ProcessOrderScreenState();
}

class _ProcessOrderScreenState extends State<ProcessOrderScreen> {
  bool _isProcessing = false;
  final TextEditingController couponController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var coupon;
  String? _selectedAddress;
  double? _latitude;
  double? _longitude;
  double _distanceKm = 0;
  String? _envio;
  String? _cupon;
  String? _selectedPaymentMethod;
  String _codeCupon = "";
  final converter = CurrencyConverter();

  void _confirmOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAddress == null || _latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una dirección.'),
          backgroundColor: Colors.red,
        ),
      );
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
      address: _selectedAddress ?? "",
      latitude: _latitude ?? 0,
      longitude: _longitude ?? 0,
      products: widget.products,
      combos: widget.combos,
      paymentMethod: _selectedPaymentMethod,
      currency: converter.selectedCurrency,
      totalDecimal: converter.convert(widget.totalDecimal.toDouble()),
      cupon: _codeCupon,
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

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
    );

    if (result != null) {
      setState(() {
        widget.totalDecimal -= _distanceKm;
        _selectedAddress = result['direccion'];
        _latitude = result['latitud'];
        _longitude = result['longitud'];
        _distanceKm = result['km'] * 0.4;
        _envio =
            "${converter.selectedCurrency} ${converter.convert(_distanceKm.toDouble()).toStringAsFixed(2)}";
        widget.totalDecimal += _distanceKm;
      });
    }
  }

  Future<void> _validateCoupon() async {
    if (_cupon == null) {
      try {
        var coupon = await fetchEntityById<Coupon>(
          couponController.text,
          'cupon/one/by',
          (data) => Coupon.fromJson(data),
        );
        if (coupon != null) {
          print('Cupón válido: ${(widget.totalDecimal - _distanceKm)}');
          setState(() {
            _codeCupon = coupon.name;
            _cupon =
                "${converter.selectedCurrency} ${converter.convert(double.parse((((widget.totalDecimal - _distanceKm) / (1 + coupon.value)) - (widget.totalDecimal - _distanceKm)).toStringAsFixed(2))).toStringAsFixed(2)}";
          });
          widget.totalDecimal += double.parse(
              ((widget.totalDecimal / (1 + coupon.value)) - widget.totalDecimal)
                  .toStringAsFixed(2));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El código del cupón no es válido')),
        );
      }
    }
    couponController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
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
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 36, 36, 36)
                    : Colors.white,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: couponController, //
                              decoration: InputDecoration(
                                labelText: 'Código de Cupón',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.white),
                              onPressed: _validateCoupon,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Tarifa de envío: ${_envio ?? 'Seleccione la ubicación'}',
                          style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Cupon: ${_cupon ?? 'No aplicado'}',
                          style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total: ${converter.selectedCurrency} ${converter.convert(widget.totalDecimal.toDouble()).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 0, 0, 0)),
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
              Text(
                'Dirección: ${_selectedAddress ?? 'Seleccione la ubicación'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _openLocationPicker,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange,
                ),
                child: Text('Seleccionar Ubicación'),
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
                    description:
                        'Realiza el pago a través de tu dispositivo móvil.',
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
