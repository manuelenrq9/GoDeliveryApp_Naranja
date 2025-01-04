// import 'package:flutter/material.dart';
// import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
// import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart'; // Asegúrate de importar MainMenu

// class CurrencySettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final converter = CurrencyConverter();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Configuración de moneda')),
//       body: ListView(
//         children: ['USD', 'VES', 'EUR'].map((currency) {
//           return ListTile(
//             title: Text(currency),
//             trailing: converter.selectedCurrency == currency
//                 ? const Icon(Icons.check, color: Colors.green)
//                 : null,
//             onTap: () {
//               converter.setCurrency(currency);

//               // Navegar al menú principal y refrescar
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => const MainMenu()),
//                 (route) => false, // Elimina todas las rutas anteriores
//               );
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';

class CurrencySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final converter = CurrencyConverter();

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de moneda')),
      body: ListView(
        children: ['USD', 'VES', 'EUR'].map((currency) {
          return ListTile(
            title: Text(currency),
            trailing: converter.selectedCurrency == currency
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () async {
              await converter.setCurrency(currency); // Guardar la selección
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainMenu()),
                (route) => false, // Eliminar todas las rutas anteriores
              );
            },
          );
        }).toList(),
      ),
    );
  }
}