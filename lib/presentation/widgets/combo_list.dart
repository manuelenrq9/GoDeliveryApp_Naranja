import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/entities/combo.dart';
import 'package:godeliveryapp_naranja/presentation/widgets/combo_card.dart';
import 'package:http/http.dart' as http;

Future<List<Combo>> fetchCombos() async {
  final response = await http.get(Uri.parse(''));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> combosData = jsonData['combos'];
    return combosData
        .map((comboJson) => Combo.fromJson(comboJson))
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch products');
  }
}

class ComboListScreen extends StatefulWidget {
  const ComboListScreen({super.key});

  @override
  State<ComboListScreen> createState() => _ComboListScreenState();
}

class _ComboListScreenState extends State<ComboListScreen> {
  late Future<List<Combo>> futureCombos;

  @override
  void initState() {
    super.initState();
    futureCombos = fetchCombos();
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene el alto de la pantalla
    double screenHeight = MediaQuery.of(context).size.height;
    // Calcula una altura adaptable para el contenedor
    double containerHeight = screenHeight * 0.32;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Combos'),
      ),
      body: FutureBuilder<List<Combo>>(
        future: futureCombos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); 
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); 
          } else if (snapshot.hasData) {
            final combos = snapshot.data!;
            return SizedBox(
              height: containerHeight, 
              child: ListView(
                scrollDirection: Axis.horizontal, 
                children: combos.map((combo) {
                  return ComboCard(
                    title: combo.name,
                    imagePath: combo.comboImage,
                    description: combo.description,
                    price: combo.specialPrice.toDouble(),
                  );
                }).toList(),
              ),
            );
          }
          return const Center(child: Text('No combos available.'));
        },
      ),
    );
  }
}

