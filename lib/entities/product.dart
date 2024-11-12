/*
{
  "name": "Raquety Picante",
  "description": "Snack en base de harina con picante",
  "image": "Aqui iria el link de la imagen",
  "price": 2,
  "currency": "USD",
  "weight": 100
}
*/
class Product {
  final String id;
  final String name;
  final String description; //falta
  final String image;
  final num price;
  final String currency; 
  final num weight;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.currency,
    required this.weight,
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
      } =>
        Product(
          id: id,
          name: name,
          description: description,
          image: image,
          price: price,
          currency: currency,
          weight: weight,
        ),
      _ => throw const FormatException('Failed to load product.'),
    };
  }
}

