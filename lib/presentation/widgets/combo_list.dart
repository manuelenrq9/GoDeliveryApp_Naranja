import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/entities/combo.dart';
import 'package:godeliveryapp_naranja/presentation/widgets/combo_card.dart';
import 'package:http/http.dart' as http;

Future<List<Combo>> fetchCombos() async {
  final response = await http.get(Uri.parse('https://orangeteam-deliverybackend-production.up.railway.app/combo'));

  if (response.statusCode == 200) {
    print('Response body: ${response.body}');
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> combosData = jsonData['combos'];
    print('Combos: $combosData');  // Verifica que los datos se están recibiendo correctamente
    return combosData.map((comboJson) => Combo.fromJson(comboJson)).toList();
  } else {
    throw Exception('Failed to fetch combos');
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
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.38; // 32% de la altura de la pantalla

    return SizedBox(
        height: containerHeight, // Asegura que ComboListScreen tenga una altura limitada
        child: FutureBuilder<List<Combo>>(
          future: futureCombos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final combos = snapshot.data!;
              return ListView(
                scrollDirection: Axis.horizontal,
                children: combos.map((combo) {
                  return ComboCard(combo: combo);
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } 

              return const Center(child: CircularProgressIndicator());
          },
        ),
    );
  }
}





