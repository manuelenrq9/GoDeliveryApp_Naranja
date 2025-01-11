class OrderReport {
  final String id;
  final String description;
  final DateTime reportDate;

  OrderReport({
    required this.id, 
    required this.description, 
    required this.reportDate
    });

  factory OrderReport.fromJson(Map<String, dynamic> json) {
    return OrderReport(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      reportDate: DateTime.parse(json['reportDate']),
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'reportDate': reportDate.toIso8601String(),
    };
  }
}
