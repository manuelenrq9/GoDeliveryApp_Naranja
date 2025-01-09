import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/data.services.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/combo/presentation/widgets/comboItemCatalog.dart';
import 'package:godeliveryapp_naranja/features/localStorage/data/local_storage.repository.dart';

// Asegúrate de tener este archivo

class ComboCatalogScreen extends StatefulWidget {
  const ComboCatalogScreen({super.key}); // Nombre actualizado

  @override
  State<ComboCatalogScreen> createState() =>
      _ComboCatalogScreenState(); // Nombre actualizado
}

class _ComboCatalogScreenState extends State<ComboCatalogScreen> {
  // Nombre actualizado
  late Future<List<Combo>> futureCombos;

  // Instancia de DataService<Combo>
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
    print("AQUI ESTAMOS EN COMBO");
    loadCombos(); // Cargar los productos desde el API
  }

  void loadCombos() {
    setState(() {
      futureCombos = comboService.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
        'Combos',
        style: TextStyle(
          color: Color.fromARGB(255, 175, 91, 7),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
                  ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 175, 91, 7)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Combo>>(
        future: futureCombos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay combos disponibles'));
          } else {
            // Si hay productos, los mostramos
            final combos = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 1, // Espaciado horizontal entre columnas
                mainAxisSpacing: 1, // Espaciado vertical entre filas
                childAspectRatio: 0.85, // Relación de aspecto de las tarjetas
              ),
              itemCount: combos.length,
              itemBuilder: (context, index) {
                return ComboItemCatalogo(
                    combo: combos[
                        index]); // Este es el widget que muestra el producto
              },
            );
          }
        },
      ),
    );
  }
}
