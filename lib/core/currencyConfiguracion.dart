import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';

class CurrencySettingsScreen extends StatefulWidget {
  @override
  _CurrencySettingsScreenState createState() => _CurrencySettingsScreenState();
}

class _CurrencySettingsScreenState extends State<CurrencySettingsScreen> {
  final converter = CurrencyConverter();
  final currencies = [
    {'code': 'USD', 'symbol': '\$', 'example': '10.00 USD'},
    {'code': 'VES', 'symbol': 'Bs.', 'example': '10.00 Bs.'},
    {'code': 'EUR', 'symbol': '€', 'example': '10.00 EUR'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Configuración de moneda',
            style: TextStyle(color: Color.fromARGB(255, 175, 91, 7)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 175, 91, 7)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainMenu()),
              (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona tu moneda preferida:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9027),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    currencies.length,
                    (index) {
                      final currency = currencies[index];
                      final isSelected =
                          converter.selectedCurrency == currency['code'];

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                converter.setCurrency(currency['code']!);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Has seleccionado ${currency['code']} (${currency['symbol']}).',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(16),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainMenu()),
                                (route) => false,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.orange[100]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.orange
                                      : Colors.grey[300]!,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currency['code']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.orange[800]
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${currency['symbol']} - Ejemplo: ${currency['example']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isSelected
                                              ? Colors.orange[600]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  AnimatedScale(
                                    scale: isSelected ? 1.2 : 1.0,
                                    duration: const Duration(milliseconds: 500),
                                    child: isSelected
                                        ? const Icon(Icons.check_circle,
                                            color: Colors.orange)
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 16), // Separación entre bloques
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
