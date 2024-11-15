class Category {
  final String id;
  final String name;
  final String image;

  const Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
        'image': String image,
      } =>
        Category(
          id: id,
          name: name,
          image: image,
        ),
      _ => throw const FormatException('Failed to load categoria'),
    };
  }
}
