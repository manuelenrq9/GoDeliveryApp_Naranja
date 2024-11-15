import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/core/titulo_lista.dart';
import 'package:godeliveryapp_naranja/features/combo/data/combo_list.dart';
import 'package:godeliveryapp_naranja/features/interfazmensaje/presentation/pages/RecoverySearchmessague.dart';
import 'package:godeliveryapp_naranja/features/product/data/product_fetch.dart';
import 'package:godeliveryapp_naranja/features/sidebar/presentation/custom_drawer.dart';
import 'package:godeliveryapp_naranja/features/category/data/categoryListScreen.dart';

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

  // Función para manejar la acción de refrescar
  Future<void> _refresh() async {
    // Aquí puedes poner tu lógica de recarga de datos, por ejemplo, volver a cargar los productos
    await Future.delayed(
        const Duration(seconds: 2)); // Simula la espera para refrescar
    setState(() {
      // Aquí actualizas el estado, si tienes algún dato que necesite ser actualizado.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              showLoadingScreen(context,
                  destination: RecoverySearchmessagueScreen());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh, // Asocia la función de refresco
        color: Colors.orange, // Establece el color del refresco a naranja
        child: ListView(
          children: [
            CategoryListScreen(),
            TituloLista(titulo: "Combos de Productos"),
            const ComboListScreen(),
            TituloLista(titulo: "Productos Populares"),
            const ProductListScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
      drawer: CustomDrawer(),
    );
  }
}
