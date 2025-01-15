import 'dart:async';
import 'package:godeliveryapp_naranja/core/dataID.services.dart';
import 'package:godeliveryapp_naranja/features/combo/data/combo_fetchID.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';

Future<List<String>> fetchItemNames(
    List<CartProduct> products, List<CartCombo> combos) async {
  List<String> items = [];
  await fetchCombos(items, combos);
  await fetchProducts(items, products);
  return items;
}

Future<void> fetchProducts(
    List<String> items, List<CartProduct> products) async {
  String id;
  Product productObject;
  for (var product in products) {
    id = product.id;
    productObject = await fetchEntityById<Product>(id, 'product/one/',
        (json) => Product.fromJson(json)); // Await the asynchronous call
    items.add(
        productObject.name); // Add the product name directly to the passed list
  }
}

Future<void> fetchCombos(List<String> items, List<CartCombo> combos) async {
  String id;
  Combo comboObject;

  for (var combo in combos) {
    id = combo.id;
    comboObject = await fetchComboById(id);
    items.add(comboObject.name);
  }
}
