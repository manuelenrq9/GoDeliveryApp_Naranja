import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/orderhistory/navbar.dart';
import '../widgets/combo_card.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
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
    // Obtiene el alto de la pantalla
    double screenHeight = MediaQuery.of(context).size.height;

    // Calcula una altura adaptable para el contenedor
    double containerHeight = screenHeight * 0.32;

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
        children: [
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryCard(title: '', iconPath: ''),
                CategoryCard(title: '', iconPath: ''),
                CategoryCard(title: '', iconPath: ''),
                CategoryCard(title: '', iconPath: ''),
                CategoryCard(title: '', iconPath: ''),
                CategoryCard(title: '', iconPath: ''),
                CategoryCard(title: '', iconPath: ''),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          SizedBox(
            height: containerHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                ComboCard(
                  title: 'Combo 1',
                  imagePath:
                      'https://quemantequilla.online/wp-content/uploads/2020/07/Combo-Quincanal-copia.jpg',
                  description: 'Pan, azucar, galleta, salsa, leche harina.',
                  price: 29.99,
                ),
                ComboCard(
                  title: 'Combo 2',
                  imagePath:
                      'https://quemantequilla.online/wp-content/uploads/2020/07/Combo-Semanal.jpg',
                  description:
                      'Harina PAN, azucar, aceite, pasta, arroz, cafe, mantequilla y salsa inglesa.',
                  price: 19.99,
                ),
                ComboCard(
                  title: 'Combo 3',
                  imagePath:
                      'https://quemantequilla.online/wp-content/uploads/2019/10/Combo-Limpieza.jpg',
                  description: 'Cloro, detergente y lavaplato.',
                  price: 24.99,
                ),
                ComboCard(
                  title: 'Combo 4',
                  imagePath:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0iI_M5dxeG0D7k2EVAFCC0-edM8OqbIR36w&s',
                  description: 'Variedades.',
                  price: 14.99,
                ),
                ComboCard(
                  title: 'Combo 5',
                  imagePath:
                      'https://quemantequilla.online/wp-content/uploads/2020/07/Combo-Semanal-Portada-1.jpg',
                  description:
                      'Combo semanal con una selección de productos esenciales para el hogar.',
                  price: 34.99,
                ),
              ],
            ),
          ),
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
