import 'dart:convert';

class Combo {
  final String id;
  final String name;
  final num specialPrice;
  final String currency;
  final String description;
  final List<String> comboImage;
  final List<String> products;
  final num weight;
  final String measurement;
  final num stock;
  final List<String> categories;
  final DateTime? caducityDate;
  final String? discount;

  Combo({
    required this.id,
    required this.name,
    required this.specialPrice,
    required this.currency,
    required this.description,
    required this.comboImage,
    required this.products,
    required this.weight,
    required this.measurement,
    required this.stock,
    required this.categories,
    this.caducityDate,
    this.discount,
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
    comboImage: List<String>.from(json['comboImages'] ?? []),
    products: List<String>.from(json['products'] ?? []),
    weight: json['weight'] as num,
    measurement: json['measurement'] as String,
    stock: json['stock'] as num,
    categories: List<String>.from(json['categories'] ?? []),
    caducityDate: json['caducityDate'] != null ? DateTime.parse(json['caducityDate']) : null,
    discount: json['discount'] as String?,
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
      'weight': weight,
      'measurement': measurement,
      'stock': stock,
      'categories': categories,
      'caducityDate': caducityDate?.toIso8601String(),
      'discount': discount,
    };
  }
}
