import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/core/titulo_lista.dart';
import 'package:godeliveryapp_naranja/features/combo/data/combo_list.dart';
import 'package:godeliveryapp_naranja/features/product/data/product_fetch.dart';
import 'package:godeliveryapp_naranja/features/category/data/categoryListScreen.dart';
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
        body: ListView( // 
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
              CategoryListScreen(),
              TituloLista(titulo: "Combos de Productos"),
              const ComboListScreen(),
              TituloLista(titulo: "Productos Populares"),
              const ProductListScreen(),              
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
