class Coupon {
  final String id;
  final String name;
  final double value;
  final String description;
  final DateTime expireDate;
  final DateTime startDate;

  Coupon({
    required this.id,
    required this.name,
    required this.value,
    required this.description,
    required this.expireDate,
    required this.startDate,
  });

  // Convertir de un JSON a un objeto Coupon
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      name: json['name'],
      value: (json['value'] as num).toDouble(),
      description: json['description'],
      expireDate: DateTime.parse(json['expireDate']),
      startDate: DateTime.parse(json['startDate']),
    );
  }

  // Convertir un objeto Coupon a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'description': description,
      'expireDate': expireDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
    };
  }
}

// Ejemplo de uso:
void main() {
  final coupon = Coupon(
    id: 'de6155ce-c301-45f7-85de-9eab097f9d67',
    name: 'VALENTIN',
    value: 0.25,
    description: '25% off in your january purchases',
    expireDate: DateTime.parse('2026-10-20T00:00:00.000Z'),
    startDate: DateTime.parse('2024-10-20T00:00:00.000Z'),
  );

  print('Coupon Name: ${coupon.name}');
  print('JSON: ${coupon.toJson()}');
}
