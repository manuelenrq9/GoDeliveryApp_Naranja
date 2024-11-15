class Product {
  final String id;
  final String name;
  final String description; //falta
  final String image;
  final num price;
  final String currency; 
  final num weight;
  final num stock;
  final String category;

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
  });

  // Deserialización del JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      price: json['price'] as num,
      currency: json['currency'] as String,
      weight: json['weight'] as num,
      stock: json['stock'] as num,
      category: json['category'] as String,
    );
  }

  // Serialización del objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'currency': currency,
      'weight': weight,
      'stock': stock,
      'category': category,
    };
  }
}

