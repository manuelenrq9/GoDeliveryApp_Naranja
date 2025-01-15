import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConfiguracion.dart';
import 'package:godeliveryapp_naranja/core/widgets/counterManager.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/pages/order_history_screen.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/pages/order_direction.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/pages/track_order_screen.dart';
import 'package:godeliveryapp_naranja/features/perfilusuario/presentation/pages/UserProfileScreen.dart';
import 'package:godeliveryapp_naranja/features/search/presentation/pages/searchscreen.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          if (widget.currentIndex == index)
            return; // Evita navegación innecesaria

          if (index == 0) {
            _controller.forward().then((_) => _controller.reverse());
          }

          widget.onTap(index); // Actualiza el índice en el widget principal
          _navigateToPage(index); // Navegar a la página correspondiente
        },
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: _buildCartIcon(),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFFFF9027),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        // Cuando navegas al home, asegúrate de que se coloree el ícono correctamente
        widget.onTap(0); // Actualiza el índice en el widget principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenu()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );

        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );

        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(context,
            // MaterialPageRoute(builder: (context) => CurrencySettingsScreen()));
        // MaterialPageRoute(builder: (context) => LocationPickerScreen()));
        // MaterialPageRoute(builder: (context) => TrackOrderScreen()));
            MaterialPageRoute(builder: (context) => UserProfileScreen()));

        break;
    }
  }

  Widget _buildCartIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Material(
          elevation: 10,
          shape: CircleBorder(),
          color: Color(0xFFFF9027),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.2).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticOut,
              ),
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: CounterManager().counterNotifier,
              builder: (context, counter, child) {
                return Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$counter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
