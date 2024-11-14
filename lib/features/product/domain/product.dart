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

  factory Product.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
        'description': String description,
        'image': String image,
        'price': num price,
        'currency': String currency,
        'weight': num weight,    
        'stock': num stock,
        'category': String category,                           
      } =>
        Product(
          id: id,
          name: name,
          description: description,
          image: image,
          price: price,
          currency: currency,
          weight: weight,
          stock: stock,
          category: category,
        ),
      _ => throw const FormatException('Failed to load product.'),
    };
  }
}

