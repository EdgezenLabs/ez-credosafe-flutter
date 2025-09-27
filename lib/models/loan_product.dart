class LoanProduct {
  final int id;
  final String name;
  final String description;
  final double interest;

  LoanProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.interest,
  });

  factory LoanProduct.fromJson(Map<String, dynamic> json) {
    return LoanProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      interest: (json['interest'] ?? 0).toDouble(),
    );
  }
}
