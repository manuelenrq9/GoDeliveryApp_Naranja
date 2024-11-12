import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

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
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) {
        _controller.forward().then((_) => _controller.reverse());
        widget.onTap(index);
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
    );
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
            child: Container(
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
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
