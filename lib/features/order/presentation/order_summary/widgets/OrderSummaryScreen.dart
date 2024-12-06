import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/delivery_address.dart';
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

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del Pedido'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          OrderHeader(),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.access_time, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Entrega hoy a las 3:00 pm',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.credit_card, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Método de pago: Cash on Delivery',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Divider(thickness: 1),
          // Lista de productos
          Column(
            children: const [
              Card(
                color: Colors.white,
                elevation: 3,
                shadowColor: Colors.grey,
                child: ProductTile(
                  name: 'Nestle Koko Krunch x2',
                  presentation: '550gm',
                  price: '\$ 6.50',
                  imageUrl:
                      'https://www.digitindahan.com.ph/cdn/shop/files/ph-11134207-7r98r-lxti9f5u2grl41_1000x.jpg?v=1721296216',
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 3,
                shadowColor: Colors.grey,
                child: ProductTile(
                  name: 'Rupchanda Soyabean Oil x1',
                  presentation: '350gm',
                  price: '\$ 18.50',
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbYbIy1obwjeGUc-l4ilH_2Q9A5IAcliREIA&s',
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 3,
                shadowColor: Colors.grey,
                child: ProductTile(
                  name: 'Fresh Refined Sugar x2',
                  presentation: '330gm',
                  price: '\$ 2.30',
                  imageUrl:
                      'https://backend.wholesaleclubltd.com/uploads/all/5JDGHeVxsQsZ3oSqnfL8fKGl5lGWZnyVdo2SrFbC.jpg',
                ),
              ),
            ],
          ),
          const Divider(thickness: 1),
          OrderSummary(),
          const Divider(),
          DeliveryTime(),
          const Divider(),
          DeliveryAddress(),
          const SizedBox(height: 16),
          ReorderButton(onPressed: () {
            // Lógica para reordenar
          }),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
