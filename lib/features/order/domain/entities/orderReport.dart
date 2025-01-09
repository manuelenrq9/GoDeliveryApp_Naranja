// class OrderReport {
//   final String id;
//   final String description;
//   final DateTime reportDate;

//   OrderReport({required this.id,required this.description,required this.reportDate});
// }


class OrderReport {
  final String id;

  OrderReport({required this.id});

  factory OrderReport.fromJson(Map<String, dynamic> json) {
    return OrderReport(id: json['_id'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
    };
  }
}
