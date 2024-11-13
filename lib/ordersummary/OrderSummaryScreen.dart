import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/ordersummary/delivery_address.dart';
import 'package:godeliveryapp_naranja/ordersummary/delivery_time.dart';
import 'package:godeliveryapp_naranja/ordersummary/order_header.dart';
import 'package:godeliveryapp_naranja/ordersummary/order_summary.dart';
import 'package:godeliveryapp_naranja/ordersummary/product_tile.dart';
import 'package:godeliveryapp_naranja/ordersummary/reorder_button.dart';

class OrderSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderHeader(),
              const SizedBox(height: 8),
              const Text('Entrega hoy a las 3:00 pm'),
              const SizedBox(height: 16),
              const Text('Metodo de pago: Cash on Delivery'),
              const Divider(thickness: 1),
              const Column(
                children: [
                  ProductTile(
                    name: 'Nestle Koko Krunchx2',
                    presentation: '550gm',
                    price: '\$ 6.50',
                    imageUrl:
                        'https://www.digitindahan.com.ph/cdn/shop/files/ph-11134207-7r98r-lxti9f5u2grl41_1000x.jpg?v=1721296216',
                  ),
                  ProductTile(
                    name: 'Rupchanda Soyabean Oilx1',
                    presentation: '350gm',
                    price: '\$ 18.50',
                    imageUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbYbIy1obwjeGUc-l4ilH_2Q9A5IAcliREIA&s',
                  ),
                  ProductTile(
                    name: 'Fresh Refined Sugar znx2',
                    presentation: '330gm',
                    price: '\$ 2.30',
                    imageUrl:
                        'https://backend.wholesaleclubltd.com/uploads/all/5JDGHeVxsQsZ3oSqnfL8fKGl5lGWZnyVdo2SrFbC.jpg',
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
                // Logic for reorder
              }),
            ],
          ),
        ),
      ),
    );
  }
}
