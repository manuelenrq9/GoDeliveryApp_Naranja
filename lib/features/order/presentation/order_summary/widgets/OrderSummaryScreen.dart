import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/delivery_address.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/delivery_date.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/delivery_time.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/order_header.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/pages/order_summary.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/product_tile.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/reorder_button.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';

class OrderSummaryScreen extends StatefulWidget {
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
            OrderHeader(),
            const SizedBox(height: 16),
            const Divider(thickness: 1, height: 32),
            _buildSection(
              icon: Icons.credit_card,
              text: 'Método de pago: Cash on Delivery',
            ),
            const Divider(thickness: 1, height: 32),
            const Text(
              'Productos en tu pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._buildProductList(),
            const Divider(thickness: 1, height: 32),
            const Text(
              'Resumen del pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            OrderSummary(),
            const SizedBox(height: 16),
            DeliveryDate(),
            const SizedBox(height: 16),
            DeliveryTime(),
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

  List<Widget> _buildProductList() {
    final products = [
      {
        'name': 'Nestle Koko Krunch x2',
        'presentation': '550gm',
        'price': '\$ 6.50',
        'imageUrl':
            'https://www.digitindahan.com.ph/cdn/shop/files/ph-11134207-7r98r-lxti9f5u2grl41_1000x.jpg?v=1721296216',
      },
      {
        'name': 'Rupchanda Soyabean Oil x1',
        'presentation': '350gm',
        'price': '\$ 18.50',
        'imageUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbYbIy1obwjeGUc-l4ilH_2Q9A5IAcliREIA&s',
      },
      {
        'name': 'Fresh Refined Sugar x2',
        'presentation': '330gm',
        'price': '\$ 2.30',
        'imageUrl':
            'https://backend.wholesaleclubltd.com/uploads/all/5JDGHeVxsQsZ3oSqnfL8fKGl5lGWZnyVdo2SrFbC.jpg',
      },
    ];

    return products
        .map((product) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ProductTile(
                name: product['name']!,
                presentation: product['presentation']!,
                price: product['price']!,
                imageUrl: product['imageUrl']!,
              ),
            ))
        .toList();
  }

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
