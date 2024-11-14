import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/presentation/widgets/combo_list.dart';
import 'package:godeliveryapp_naranja/orderhistory/navbar.dart';
import 'package:godeliveryapp_naranja/presentation/widgets/custom_drawer.dart';
import '../widgets/combo_card.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // Variable para controlar el índice seleccionado en el BottomNavigationBar
  int _currentIndex = 0;

  // Función para manejar el cambio de índice
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con el botón de menú
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Acción para abrir el menú (Drawer)
                Scaffold.of(context)
                    .openDrawer(); // Ahora Scaffold.of() funciona correctamente
              },
            );
          },
        ),
        title: Center(
          child: Image.asset(
            'images/LogoLetrasGoDely.png',
            height: 40,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Acción para abrir la búsqueda
            },
          ),
        ],
      ),
      // Body de la pantalla
      body: ListView(
        children: const [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryCard(title: 'Comida', iconPath: 'images/Comida.png'),
                CategoryCard(title: 'Bebidas', iconPath: 'images/Bebidas.png'),
                CategoryCard(title: 'Postres', iconPath: 'images/Postres.png'),
                CategoryCard(title: 'Snacks', iconPath: 'images/Snacks.png'),
                CategoryCard(
                    title: 'Mexicana', iconPath: 'images/Comida Mexicana.png'),
                CategoryCard(title: 'Licores', iconPath: 'images/Licores2.png'),
              ],
            ),
          ),
          ComboListScreen(),
          ProductListScreen(),
        ],
      ),
      // Agregar CustomNavBar en el bottomNavigationBar
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
      // Aquí agregamos el CustomDrawer
      drawer: CustomDrawer(),
    );
  }
}
