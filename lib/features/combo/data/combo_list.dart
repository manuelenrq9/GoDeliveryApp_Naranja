import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/combo/presentation/widgets/combo_card.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';

class ComboListScreen extends StatefulWidget {
  const ComboListScreen({super.key});

  @override
  State<ComboListScreen> createState() => _ComboListScreenState();
}

class _ComboListScreenState extends State<ComboListScreen> {
  late Future<List<Combo>> futureCombos = Future.value([]);
  final DataService<Combo> comboService = DataService<Combo>(
    endpoint: '/bundle/many',
    repository: GenericRepository<Combo>(
      storageKey: 'combos',
      fromJson: Combo.fromJson,
      toJson: (combo) => combo.toJson(),
    ),
    fromJson: Combo.fromJson,
  );

  @override
  void initState() {
    super.initState();
    loadCombos(); // Llama a loadCombos al iniciar la pantalla
  }

  void loadCombos() async {
    futureCombos = comboService.loadData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight =
        screenHeight * 0.38; // 38% de la altura de la pantalla

    return SizedBox(
      height: containerHeight, // Limita la altura de ComboListScreen
      child: FutureBuilder<List<Combo>>(
        future: futureCombos,
        builder: (context, snapshot) {
          // Verifica el estado de la conexión y muestra el cargador mientras espera
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.orange));
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
                return ComboCard(
                    combo: combo); // Se crea una tarjeta para cada combo
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
