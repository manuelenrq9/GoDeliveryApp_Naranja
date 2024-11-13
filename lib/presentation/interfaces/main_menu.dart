import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/presentation/widgets/combo_list.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override

   _MainMenuState createState() => _MainMenuState();

}


class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(

        appBar: AppBar( // Color de la barra superior
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Accion para abrir el menu
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
              // Accion para abrir el menu
            },
          ),
        ],
      ),
        body: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
              const SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Combos de Productos',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // Acción ver más combos
                      },
                      child: const Text(
                        'Ver más',
                        style: TextStyle(color: Color(0xFFFF7000)),
                      ),
                    ),
                  ],
                ),
              ),
              const ComboListScreen(),
              const ProductListScreen(),              
          ],
        )
    );

  }
  }
