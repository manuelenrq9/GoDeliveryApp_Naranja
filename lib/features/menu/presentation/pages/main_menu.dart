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
import 'package:godeliveryapp_naranja/features/product/presentation/widgets/product_list.dart';
import 'package:godeliveryapp_naranja/features/sidebar/presentation/custom_drawer.dart';
import 'package:godeliveryapp_naranja/features/category/data/categoryListScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../product/data/product_fetch.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  late String selectedCurrency;
  int _currentIndex = 0;
  ThemeMode _themeMode = ThemeMode.light;

  late AnimationController _categoryController;
  late AnimationController _comboController;
  late AnimationController _productController;
  late AnimationController _menuController;

  late Animation<double> _categoryAnimation;
  late Animation<double> _comboAnimation;
  late Animation<double> _productAnimation;
  late Animation<Offset> _menuAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCurrency();
    _loadThemeMode();
    CounterManager().loadCounterFromStorage();

    // Inicializar controladores de animación
    _categoryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _comboController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _productController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Inicializar las animaciones luego de crear los controladores
    _categoryAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _categoryController, curve: Curves.easeIn));
    _comboAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _comboController, curve: Curves.easeIn));
    _productAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _productController, curve: Curves.easeIn));
    _menuAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _menuController, curve: Curves.easeInOut));

    // Iniciar las animaciones
    _categoryController.forward();
    _comboController.forward();
    _productController.forward();
    _menuController.forward();
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

  /// Almacena el modo de tema
  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode.toString());
  }

  /// Carga el modo de tema
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode');

    if (themeModeString != null) {
      setState(() {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.light,
        );
      });
    }
  }

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _saveThemeMode(themeMode);
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

  @override
  void dispose() {
    _categoryController.dispose();
    _comboController.dispose();
    _productController.dispose();
    _menuController.dispose();
    super.dispose();
  }
}
