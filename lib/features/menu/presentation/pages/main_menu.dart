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

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  String selectedCurrency = 'USD';
  int _currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          child: Image.asset('images/LogoLetrasGoDely.png', height: 40),
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
        onRefresh: _refresh,
        color: Colors.orange,
        child: ListView(
          children: [
            SlideTransition(
              position: _menuAnimation,
              child: FadeTransition(
                opacity: _categoryAnimation,
                child: CategoryListScreen(),
              ),
            ),
            SlideTransition(
              position: _menuAnimation,
              child: FadeTransition(
                opacity: _comboAnimation,
                child: TituloLista(
                  titulo: "Combos de Productos",
                  next: ComboCatalogScreen(),
                ),
              ),
            ),
            SlideTransition(
              position: _menuAnimation,
              child: FadeTransition(
                opacity: _comboAnimation,
                child: const ComboListScreen(),
              ),
            ),
            SlideTransition(
              position: _menuAnimation,
              child: FadeTransition(
                opacity: _productAnimation,
                child: TituloLista(
                  titulo: "Productos Populares",
                  next: ProductCatalogScreen(),
                ),
              ),
            ),
            SlideTransition(
              position: _menuAnimation,
              child: FadeTransition(
                opacity: _productAnimation,
                child: const ProductListScreen(),
              ),
            ),
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

  @override
  void dispose() {
    _categoryController.dispose();
    _comboController.dispose();
    _productController.dispose();
    _menuController.dispose();
    super.dispose();
  }
}
