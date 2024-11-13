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
    required this.products
    }); 

  factory Combo.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
        'specialPrice': num specialPrice,
        'currency': String currency,
        'description': String description,
        'comboImage': String comboImage,
        'products': List<String> products,                               
      } =>
        Combo(
          id: id,
          name: name,
          specialPrice: specialPrice,
          currency: currency,
          description: description,
          comboImage: comboImage,
          products: products,
        ),
      _ => throw const FormatException('Failed to load combo.'),
    };
  }
}
