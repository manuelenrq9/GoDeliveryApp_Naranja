class Discount {
  final String id;
  final String name;
  final String description;
  final DateTime expireDate;
  final DateTime initDate;
  final double percentage;

  Discount({
    required this.id,
    required this.name,
    required this.description,
    required this.expireDate,
    required this.initDate,
    required this.percentage,
  });

  // Método para mapear un JSON a un objeto Discount
  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      expireDate: DateTime.parse(json['expireDate'] as String),
      initDate: DateTime.parse(json['initDate'] as String),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  // Método para convertir un objeto Discount a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'expireDate': expireDate.toIso8601String(),
      'initDate': initDate.toIso8601String(),
      'percentage': percentage,
    };
  }
}
