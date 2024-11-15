import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/core/titulo_lista.dart';
import 'package:godeliveryapp_naranja/features/category/presentation/widgets/category_card.dart';
import 'package:godeliveryapp_naranja/features/combo/data/combo_list.dart';
import 'package:godeliveryapp_naranja/features/product/data/product_fetch.dart';
// Asegúrate de importar el CustomNavBar

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Acción para abrir el menú
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
        body: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: const [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryCard(title: 'Comida', iconPath: 'images/Comida.png'),
                    CategoryCard(title: 'Bebidas', iconPath: 'images/Bebidas.png'),
                    CategoryCard(title: 'Postres', iconPath: 'images/Postres.png'),
                    CategoryCard(title: 'Snacks', iconPath: 'images/Snacks.png'),
                    CategoryCard(title: 'Mexicana', iconPath: 'images/Comida Mexicana.png'),
                    CategoryCard(title: 'Licores', iconPath: 'images/Licores2.png'),
                  ],
                ),
                ),
              TituloLista(titulo: "Combos de Productos"),
               ComboListScreen(),
              TituloLista(titulo: "Productos Populares"),
              ProductListScreen(),
                           
          ],
        ),
      // Agregar CustomNavBar en el bottomNavigationBar
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
