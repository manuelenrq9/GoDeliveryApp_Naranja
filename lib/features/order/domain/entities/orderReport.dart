class OrderReport {
  final String id;
  final String description;
  final DateTime reportDate;

  OrderReport({
    required this.id,
    this.description = '',
    DateTime? reportDate,
  }) : reportDate = reportDate ?? DateTime.now(); // Default to current date
}
