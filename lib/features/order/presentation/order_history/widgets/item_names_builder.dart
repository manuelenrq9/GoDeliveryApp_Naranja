import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/usecases/fetch_item_names.dart';

class ItemNamesBuilder extends StatefulWidget {
  final List<CartProduct> products; // Declare products
  final List<CartCombo> combos; // Declare combos

  const ItemNamesBuilder({
    Key? key,
    required this.products, // Require products to be passed
    required this.combos, // Require combos to be passed
  }) : super(key: key);
  
  @override
  State<ItemNamesBuilder> createState() => _ItemNamesBuilderState();
}

class _ItemNamesBuilderState extends State<ItemNamesBuilder> {
  late Future<List<String>> itemNames; // Declare itemNames

  @override
  void initState() {
    super.initState();
    loadNames();
    setState(() {});
  }

  void loadNames(){
    itemNames = fetchItemNames(widget.products, widget.combos);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: itemNames, // Use FutureBuilder with the fetch method
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.orange,
          )); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle error case
        } else if (snapshot.hasData) {
        // Limit to first 5 items and create a row
        List<String> limitedItems = snapshot.data!.take(5).toList();

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: limitedItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add some spacing between items
              child: Chip(
                label: Text(item, style: const TextStyle(fontSize: 12)), // Display each item name in a Chip
              ),
            );
          }).toList(),
        );
      } else {
          return Text('No items found.'); // Handle no data case
        }
      },
    );
  }
}