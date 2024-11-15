class Category {
  final String id;
  final String name;
  final String image;

  const Category({
    required this.id,
    required this.name,
    required this.image,
  });

    // Método de fábrica para convertir JSON en un objeto Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],      // Accede al valor de 'id' en el mapa
      name: json['name'],  // Accede al valor de 'name' en el mapa
      image: json['image'], // Accede al valor de 'image' en el mapa
    );
  }

  // Método toJson para convertir el objeto Category en un Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
