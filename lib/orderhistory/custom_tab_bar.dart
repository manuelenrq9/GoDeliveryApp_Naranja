import 'package:flutter/material.dart';
import 'order_card.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFF7000),
          tabs: const [
            Tab(
              text: 'Activo(2)',
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: 'Pedidos anteriores(19)',
              icon: Icon(Icons.history),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              // Active Orders
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  OrderCard(
                    date: 'Sun, 14 May, 2020',
                    orderId: '26754523',
                    price: 3560,
                    status: 'Delivered',
                    items: [
                      'Fanta (2)',
                      'Golden Harvest Samosa (3)',
                      'Pringles Sour Cream Onion (2)',
                      'Wasabi Green Peas (2)',
                      'Creamo Wafer Rolls (2)',
                    ],
                    deliveryTime: '12:45 pm',
                  ),
                ],
              ),
              // Past Orders
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  OrderCard(
                    date: 'Sun, 10 May, 2020',
                    orderId: '1215787',
                    price: 980,
                    status: 'Cancelado',
                    items: [
                      'Rupchanda Soybean Oil (1)',
                      'Radhuni Chili Powder (2)',
                      'Foster Clark Custard Powder (2)',
                      'Fresh Mango (5)',
                    ],
                    deliveryTime: 'Cancelado',
                  ),
                  OrderCard(
                    date: 'Tue, 9 May, 2020',
                    orderId: '11574669',
                    price: 6700,
                    status: 'Delivered',
                    items: [
                      'Fanta (2)',
                      'Golden Harvest Samosa (3)',
                      'Pringles Sour Cream Onion (2)',
                      'Wasabi Green Peas (2)',
                      'Creamo Wafer Rolls (2)',
                    ],
                    deliveryTime: '3:34 pm',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
