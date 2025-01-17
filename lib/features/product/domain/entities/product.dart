import 'package:equatable/equatable.dart';

class Product extends Equatable{
  final String id;
  final String name;
  final String description; //falta
  final List<String> image;
  final num price;
  final String currency;
  final num weight;
  final num stock;
  final List<String> category;
  final String measurement;
  final DateTime? caducityDate;
  final String? discount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.currency,
    required this.weight,
    required this.stock,
    required this.category,
    required this.measurement,
    this.caducityDate,
    this.discount,
  });

  // Deserialización del JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        image: List<String>.from(json['images'] ?? []),
        // price: json['price'] as num,
        price: json['price'] is String
          ? num.tryParse(json['price']) ?? 0 // Convierte String a num
          : json['price'] as num, 
        currency: json['currency'] as String,
        weight: json['weight'] as num,
        stock: json['stock'] as num,
        category: List<String>.from(json['categories'] ?? []),
        measurement: json['measurement'] as String,
        caducityDate: json['caducityDate'] != null ? DateTime.parse(json['caducityDate']) : null,
        discount: json['discount'] as String?,
        );
  }

  // Serialización del objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': image,
      'price': price,
      'currency': currency,
      'weight': weight,
      'stock': stock,
      'categories': category,
      'measurement': measurement,      
      'caducityDate': caducityDate?.toIso8601String(),
      'discount': discount,
    };
  }

   @override
  List<Object?> get props => [id,name,description,image,price,currency,weight,stock,
    category, measurement, caducityDate, discount ];
}

