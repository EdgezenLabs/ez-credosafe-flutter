class ApplicationModel {
  final int id;
  final double amount;
  final String status;
  final String createdAt;

  ApplicationModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'unknown',
      createdAt: json['created_at'] ?? '',
    );
  }
}
