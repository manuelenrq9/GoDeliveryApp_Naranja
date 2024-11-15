import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String name;
  final String presentation;
  final String price;
  final String imageUrl;

  const ProductTile({
    required this.name,
    required this.presentation,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(name),
      subtitle: Text(presentation),
      trailing: Text(price),
    );
  }
}
