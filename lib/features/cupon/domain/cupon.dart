class Coupon {
  // final String id;
  final String name;
  final double value;
  // final String description;
  final DateTime expireDate;
  // final DateTime startDate;

  Coupon({
    // required this.id,
    required this.name,
    required this.value,
    // required this.description,
    required this.expireDate,
    // required this.startDate,
  });

  // Convertir de un JSON a un objeto Coupon
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      // id: json['id'],
      name: json['code'],
      value: (json['amount'] as num).toDouble(),
      // description: json['description'],
      expireDate: DateTime.parse(json['expiration_date']),
      // startDate: DateTime.parse(json['startDate']),
      // name: json['name'],
      // value: (json['value'] as num).toDouble(),
      // expireDate: DateTime.parse(json['expireDate']),
    );
  }

  // Convertir un objeto Coupon a JSON
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'code': name,
      'amount': value,
      // 'description': description,
      'expiration_date': expireDate.toIso8601String(),
      // 'startDate': startDate.toIso8601String(),
      // 'name': name,
      // 'value': value,
      // 'expireDate': expireDate.toIso8601String(),
    };
  }
}
