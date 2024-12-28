import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/product/data/product_search.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  void dispose() {
    _debounce?.cancel(); // Cancelar el timer si el widget es destruido
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Deshabilita el back button automático
        toolbarHeight: 60.0, // Ajusta la altura de la AppBar
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFFFF7000)),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainMenu()));
                  },
                ),
                Expanded(
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                        color: Color(0xFFFF7000),
                        width: 2.0,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFFF7000),
                        ),
                        hintText: "Buscar productos...",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      onChanged: (_) {
                        _onSearchChanged(_searchController.text);
                      },
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  ),
                IconButton(
                  icon:
                      const Icon(Icons.shopping_cart, color: Color(0xFFFF7000)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true, // Esto hace que la lista se ajuste al contenido
          physics:
              NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento interno de ListView
          children: [
            if (_searchController.text.isNotEmpty)
            ProductListSearch(
              searchText: _searchController.text,
            ),
          ],
        ),
      ),
    );
  }

  // Método para manejar los cambios en el campo de búsqueda
  void _onSearchChanged(String query) {
    print("DENTRO DEL SEARCH CHANGED");
    if (query.isNotEmpty) {
      if (_debounce?.isActive ?? false)
      _debounce?.cancel(); // Cancela el timer anterior si lo hay
    _debounce = Timer(const Duration(milliseconds: 500), () {
      print("Dentro del debounce");
      setState(() {
      });
    });
    }
  }
}
