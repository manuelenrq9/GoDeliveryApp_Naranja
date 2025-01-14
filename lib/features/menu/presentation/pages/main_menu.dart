import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/core/titulo_lista.dart';
import 'package:godeliveryapp_naranja/core/widgets/counterManager.dart';
import 'package:godeliveryapp_naranja/features/combo/presentation/pages/comboCatalog.dart';
import 'package:godeliveryapp_naranja/features/product/presentation/pages/ProductCatalago.dart';
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
  late String selectedCurrency;
  int _currentIndex = 0;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _initializeCurrency();
    CounterManager().loadCounterFromStorage();
  }

  Future<void> _initializeCurrency() async {
    final converter = CurrencyConverter();
    setState(() {
      selectedCurrency = converter.selectedCurrency;
    });
    print('MONEDA ${selectedCurrency}');
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _refresh() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const MainMenu()));
  }

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  // Fondo degradado solo para el Modo Degradado
  ThemeData getGradientTheme() {
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black, // Íconos negros para buena visibilidad
        elevation: 0,
      ),
      scaffoldBackgroundColor:
          Colors.transparent, // Deja el fondo transparente para el gradiente
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 4,
        ),
        scaffoldBackgroundColor:
            Colors.white, // Fondo blanco para el modo claro
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 4,
        ),
        scaffoldBackgroundColor:
            Colors.black, // Fondo negro para el modo oscuro
      ),
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: _themeMode == ThemeMode.system
              ? Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 0, 0), // Negro
                        Color.fromARGB(255, 0, 0, 0), // Negro
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                )
              : null,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
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
            PopupMenuButton<ThemeMode>(
              icon: const Icon(Icons.brightness_6),
              onSelected: _changeTheme,
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ThemeMode>>[
                const PopupMenuItem<ThemeMode>(
                  value: ThemeMode.light,
                  child: Text('Modo Claro'),
                ),
                const PopupMenuItem<ThemeMode>(
                  value: ThemeMode.dark,
                  child: Text('Modo Oscuro'),
                ),
                const PopupMenuItem<ThemeMode>(
                  value: ThemeMode.system,
                  child: Text('Modo Degradado'),
                ),
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          color: Colors.orange,
          child: _themeMode == ThemeMode.system
              ? Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 0, 0), // Naranja claro
                        const Color.fromARGB(255, 168, 62, 0) // Blanco
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListView(
                    children: [
                      CategoryListScreen(),
                      TituloLista(
                        titulo: "Combos de Productos",
                        next: ComboCatalogScreen(),
                      ),
                      const ComboListScreen(),
                      TituloLista(
                        titulo: "Productos Populares",
                        next: ProductCatalogScreen(),
                      ),
                      const ProductListScreen(),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    CategoryListScreen(),
                    TituloLista(
                      titulo: "Combos de Productos",
                      next: ComboCatalogScreen(),
                    ),
                    const ComboListScreen(),
                    TituloLista(
                      titulo: "Productos Populares",
                      next: ProductCatalogScreen(),
                    ),
                    const ProductListScreen(),
                  ],
                ),
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
        ),
        drawer: CustomDrawer(),
      ),
    );
  }
}
