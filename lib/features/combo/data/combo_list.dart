import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/combo/presentation/widgets/combo_card.dart';
import 'package:http/http.dart' as http;
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<List<Combo>> fetchCombos() async {
  try {
    final response = await http.get(Uri.parse(
        'https://orangeteam-deliverybackend-production.up.railway.app/combo'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> combosData = jsonData['combos'];

      // Verifica los combos que estamos recibiendo de la API
      print('Combos recibidos: $combosData');
      
      return combosData.map((comboJson) => Combo.fromJson(comboJson)).toList();
    } else {
      throw Exception('Failed to fetch combos');
    }
  } catch (e) {
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
  late Future<List<Combo>> futureCombos = Future.value([]); // Future vacío al inicio

  final _comboRepository = GenericRepository<Combo>(
    storageKey: 'combos', // El almacenamiento clave para combos
    fromJson: (json) => Combo.fromJson(json), // Función de deserialización
    toJson: (combo) => combo.toJson(), // Función de serialización
  );

  @override
  void initState() {
    super.initState();
    loadCombos(); // Llama a loadCombos al iniciar la pantalla
  }

  // Método que carga los combos según la conectividad
  void loadCombos() async {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      // Hay conexión a Internet, entonces busca los combos en la API
      try {
        final combos = await fetchCombos(); // Espera los combos desde la API
        await _comboRepository.saveData(combos); // Guarda los combos en el localStorage
        print('Combos guardados: $combos'); // Verifica que se guardaron en el localStorage
        setState(() {
          futureCombos = Future.value(combos); // Actualiza el Future con los nuevos datos
        });
      } catch (error) {
        setState(() {
          futureCombos = Future.value([]); // Si ocurre un error, mostramos una lista vacía
        });
        print('Error al obtener combos desde la API: $error'); // Mensaje de error en consola
      }
    } else {
      // No hay conexión a Internet, entonces carga los combos desde localStorage
      final savedCombos = await _comboRepository.loadData();
      print('Combos cargados desde localStorage: $savedCombos');
      setState(() {
        futureCombos = Future.value(savedCombos.isNotEmpty ? savedCombos : []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.38; // 38% de la altura de la pantalla

    return SizedBox(
      height: containerHeight, // Limita la altura de ComboListScreen
      child: FutureBuilder<List<Combo>>(
        future: futureCombos,
        builder: (context, snapshot) {
          // Verifica el estado de la conexión y muestra el cargador mientras espera
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          }

          // Si ocurre un error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Si hay datos en el snapshot
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final combos = snapshot.data!;
            return ListView(
              scrollDirection: Axis.horizontal,
              children: combos.map((combo) {
                return ComboCard(combo: combo); // Se crea una tarjeta para cada combo
              }).toList(),
            );
          }

          // Si no hay datos o están vacíos
          return const Center(child: Text('No hay combos disponibles'));
        },
      ),
    );
  }
}
