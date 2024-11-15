import 'dart:convert';

class Combo {
  final String id;
  final String name;
  final num specialPrice;
  final String currency;
  final String description;
  final String comboImage;
  final List<String> products;

  Combo({
    required this.id,
    required this.name,
    required this.specialPrice,
    required this.currency,
    required this.description,
    required this.comboImage,
    required this.products,
  });

  // Deserialización del JSON
  factory Combo.fromJson(dynamic json) {
  if (json is String) {
    json = jsonDecode(json); // Decodifica si es un string
  }
  return Combo(
    id: json['id'] as String,
    name: json['name'] as String,
    specialPrice: json['specialPrice'] as num,
    currency: json['currency'] as String,
    description: json['description'] as String,
    comboImage: json['comboImage'] as String,
    products: List<String>.from(json['Products'] ?? []),
  );
}



  // Método de serialización
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialPrice': specialPrice,
      'currency': currency,
      'description': description,
      'comboImage': comboImage,
      'products': products,
    };
  }
}
