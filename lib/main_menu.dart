import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/category_card.dart';
class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
   _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( /*
        appBar: AppBar( // Color de la barra superior
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Accion para abrir el menu
          },
        ),
        title: Center(
          child: Image.asset(
            '',
            height: 40,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Accion para busqueda de productos
            },
          ),
        ],
      ), */
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryCard(title:'Food', iconPath: 'images/pizza.png',),
                  CategoryCard(title:'Food', iconPath: 'images/pizza.png',),
                  CategoryCard(title:'Food', iconPath: 'images/pizza.png',),
                  CategoryCard(title:'Food', iconPath: 'images/pizza.png',),
                  CategoryCard(title:'Food', iconPath: 'images/pizza.png',),
              
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}