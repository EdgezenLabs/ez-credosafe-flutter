class AdminLoanApplication {
  final String? applicationId;
  final String? userName;
  final String? loanType;
  final double? requestedAmount;
  final String? status;
  final List<Map<String, dynamic>> documents;

  AdminLoanApplication({
    this.applicationId,
    this.userName,
    this.loanType,
    this.requestedAmount,
    this.status,
    List<Map<String, dynamic>>? documents,
  }) : documents = documents ?? const [];

  factory AdminLoanApplication.fromJson(Map<String, dynamic> json) {
    final docs = (json['documents'] as List<dynamic>?)
            ?.map((d) => Map<String, dynamic>.from(d as Map))
            .toList() ??
        [];
    return AdminLoanApplication(
      applicationId: json['application_id']?.toString(),
      userName: json['user_name'] ?? json['user'] ?? json['applicant_name'],
      loanType: json['loan_type']?.toString(),
      requestedAmount: (json['requested_amount'] is num) ? (json['requested_amount'] as num).toDouble() : null,
      status: json['status']?.toString(),
      documents: docs,
    );
  }
}
