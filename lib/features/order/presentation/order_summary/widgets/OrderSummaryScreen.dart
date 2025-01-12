import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/core/dataID.services.dart';
import 'package:godeliveryapp_naranja/features/combo/data/combo_fetchID.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderPayment.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/delivery_address.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/delivery_date.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/delivery_time.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/order_header.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/pages/order_summary.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/product_tile.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/reorder_button.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/features/product/data/product_fetchID.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';

class OrderSummaryScreen extends StatefulWidget {
  final Order order;

  const OrderSummaryScreen({super.key, required this.order});
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  int _selectedIndex = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime lastDate = today.add(const Duration(days: 7));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<OrderPayment> payment = widget.order.paymentMethod;

    String paymentMethod = '';
    payment.forEach((payment) {
      paymentMethod = payment.paymentMethod;
    });

    String formatedId = widget.order.id.length > 8
        ? widget.order.id.substring(0, 8)
        : widget.order.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resumen del Pedido',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeader(orderNumber: formatedId, status: widget.order.status),
            const SizedBox(height: 16),
            const Divider(thickness: 1, height: 32),
            _buildSection(
              icon: Icons.credit_card,
              text: 'Método de pago: ${paymentMethod}',
            ),
            const Divider(thickness: 1, height: 32),
            const Text(
              'Productos en tu pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // ..._buildProductList(),
            FutureBuilder<List<Widget>>(
              future: _buildProductList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Column(children: snapshot.data!);
                } else {
                  return const Text('No products available');
                }
              },
            ),
            const Divider(thickness: 1, height: 32),
            const Text(
              'Resumen del pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            OrderSummary(order: widget.order),
            const SizedBox(height: 16),
            DeliveryDate(order: widget.order),
            const SizedBox(height: 16),
            DeliveryTime(order: widget.order),
            const Divider(thickness: 1, height: 32),
            DeliveryAddress(),
            const SizedBox(height: 32),
            Center(
              child: ReorderButton(onPressed: () {
                _showReorderConfirmationDialog(context);
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepOrange, size: 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Future<List<Widget>> _buildProductList() async {
    List<CartProduct> products = widget.order.products;
    List<CartCombo> combos = widget.order.combos;

    List<Product> productList = [];
    try {
      for (var product in products) {
        var id = product.id;
        var productObject = await fetchEntityById<Product>(id, 'product/one',
            (json) => Product.fromJson(json)); // Await the asynchronous call
        productList
            .add(productObject); //    Add the product object to the productList
      }
    } catch (e) {
      print('Error fetching productos: \$e');
    }

    List<Combo> comboList = [];
    try {
      for (var cartCombo in combos) {
        Combo combo = await fetchComboById(cartCombo.id);
        comboList.add(combo);
      }
    } catch (e) {
      print('Error fetching combos: \$e');
    }

    return List<Widget>.generate(productList.length + comboList.length,
        (index) {
      if (index < productList.length) {
        final product = productList[index];
        final quantity = products[index].quantity;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ProductTile(
            name: product.name,
            presentation: '${product.weight}${product.measurement}',
            price: '$quantity',
            imageUrl: product.image.isNotEmpty ? product.image.first : '',
          ),
        );
      } else {
        final comboIndex = index - productList.length;
        final combo = comboList[comboIndex];
        final quantityCombo = combos[comboIndex].quantity;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ProductTile(
            name: combo.name,
            presentation: '${combo.weight}${combo.measurement}',
            price: '$quantityCombo',
            imageUrl: combo.comboImage.isNotEmpty ? combo.comboImage.first : '',
          ),
        );
      }
    });
  }

  // Future<List<Widget>> _buildProductList() async {
  //   List<CartProduct> products = widget.order.products;

  //   List<Product> productList = [];
  //   try {
  //     for (var cartProduct in widget.order.products) {
  //       Product product = await fetchProductById(cartProduct.id);
  //       productList.add(product);
  //     }
  //   } catch (e) {
  //     print('Error fetching products: \$e');
  //   }

  //   return products
  //       .map((product) => Card(
  //             margin: const EdgeInsets.symmetric(vertical: 8.0),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             elevation: 2,
  //             child: ProductTile(
  //               name: product['name']!,
  //               presentation: product['presentation']!,
  //               price: product['price']!,
  //               imageUrl: product['imageUrl']!,
  //             ),
  //           ))
  //       .toList();
  // }

  void _showReorderConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Pedido realizado',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            '¡Tu pedido se ha realizado con éxito! Pronto recibirás la confirmación de entrega.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.deepOrange, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
