import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/domain/usecases/get_orders_quantity_usecase.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/active_orders_list.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/past_orders_list.dart';

class CustomTabBar extends StatefulWidget {
  final TabController tabController;

  CustomTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final GetOrdersQuantityUsecase usecase = GetOrdersQuantityUsecase();
  late Future<num> quantity;

  void loadQuantity() async {
    quantity = usecase.getActiveOrdersQuantity();
  }

  @override
  void initState() {
    super.initState();
    loadQuantity();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: widget.tabController,
          labelColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFF7000),
          tabs: [
            FutureBuilder<num>(
              future: quantity,
              builder: (BuildContext context, AsyncSnapshot<num> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Tab(
                    text: 'Activo...',
                    icon: Icon(Icons.directions_car),
                  );
                } else if (snapshot.hasError) {
                  return Tab(
                    text: 'Activo(0)', // Default value in case of error
                    icon: Icon(Icons.directions_car),
                  );
                } else {
                  return Tab(
                    text: 'Activo(${snapshot.data})', // Display the quantity
                    icon: Icon(Icons.directions_car),
                  );
                }
              },
            ),
            Tab(
              text: 'Pedidos anteriores',
              icon: Icon(Icons.history),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: [
              ActiveOrdersScreen(),
              PastOrdersScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
