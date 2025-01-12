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
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.grey,
          elevation: 4,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
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
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          color: Colors.orange,
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
