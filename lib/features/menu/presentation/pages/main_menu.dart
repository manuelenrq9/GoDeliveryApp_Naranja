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

  ThemeMode _themeMode = ThemeMode.light; // Tema inicial

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

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  Future<void> _refresh() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const MainMenu()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
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
            PopupMenuButton<String>(
              icon:
                  const Icon(Icons.brightness_6), // Ícono del selector de tema
              onSelected: (value) {
                if (value == 'Claro') {
                  _changeTheme(ThemeMode.light);
                } else if (value == 'Oscuro') {
                  _changeTheme(ThemeMode.dark);
                } else if (value == 'Degradado') {
                  _changeTheme(ThemeMode.system);
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Claro', 'Oscuro', 'Degradado'}
                    .map((String choice) => PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        ))
                    .toList();
              },
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
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        drawer: CustomDrawer(),
      ),
    );
  }
}
