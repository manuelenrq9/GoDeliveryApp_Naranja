import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/combo/presentation/widgets/combo_card.dart';
import 'package:http/http.dart' as http;
import 'package:godeliveryapp_naranja/repositories/local_storage.repository.dart';

Future<List<Combo>> fetchCombos() async {
  try {
    final response = await http.get(Uri.parse(
        'https://orangeteam-deliverybackend-production.up.railway.app/combo'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> combosData = jsonData[
          'combos']; // Verifica que los datos se están recibiendo correctamente
      return combosData.map((comboJson) => Combo.fromJson(comboJson)).toList();
    } else {
      throw Exception('Failed to fetch combos');
    }
  } catch (e) {
    // Verificamos si el error es de tipo SocketException
    if (e is SocketException) {
      throw 'No tienes conexión a Internet';
    } else {
      throw Exception('Error al cargar los combos');
    }
  }
}

class ComboListScreen extends StatefulWidget {
  const ComboListScreen({super.key});

  @override
  State<ComboListScreen> createState() => _ComboListScreenState();
}

class _ComboListScreenState extends State<ComboListScreen> {
  // Inicializa futureCombos con un valor predeterminado (lista vacía)
  late Future<List<Combo>> futureCombos = Future.value([]);

  final _comboRepository = GenericRepository<Combo>(
    storageKey: 'combos', // El almacenamiento clave para combos
    fromJson: (json) => Combo.fromJson(json), // Función de deserialización
    toJson: (combo) => combo.toJson(), // Función de serialización
  );

  @override
  void initState() {
    super.initState();
    loadCombos();
  }

  void loadCombos() async {
    // Intenta cargar combos del almacenamiento local
    final savedCombos = await _comboRepository.loadData(); 
    if (savedCombos.isNotEmpty) {
      // Si hay combos guardados, asigna futureCombos a estos datos
      setState(() {
        futureCombos = Future.value(savedCombos);
      });
    } else {
      // Si no hay combos guardados, haz la solicitud HTTP
      futureCombos = fetchCombos();
      futureCombos.then((combos) {
        // Guarda los combos recuperados para persistencia
        _comboRepository.saveData(combos);
      });
      setState(() {}); // Trigger a rebuild when `futureCombos` is assigned
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight =
        screenHeight * 0.38; // 32% de la altura de la pantalla

    return SizedBox(
      height:
          containerHeight, // Asegura que ComboListScreen tenga una altura limitada
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

          return const Center(
              child: CircularProgressIndicator(
            color: Colors.orange,
          ));
        },
      ),
    );
  }
}
