class LoanApplicationRequest {
  final String loanType;
  final double requestedAmount;
  final String purpose;
  final String employmentType;
  final double monthlyIncome;
  final double existingEmis;

  LoanApplicationRequest({
    required this.loanType,
    required this.requestedAmount,
    required this.purpose,
    required this.employmentType,
    required this.monthlyIncome,
    required this.existingEmis,
  });

  Map<String, dynamic> toJson() {
    return {
      'loan_type': loanType,
      'requested_amount': requestedAmount,
      'purpose': purpose,
      'employment_type': employmentType,
      'monthly_income': monthlyIncome,
      'existing_emis': existingEmis,
    };
  }
}

class LoanApplicationResponse {
  final String status;
  final String message;
  final LoanApplicationData? data;

  LoanApplicationResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoanApplicationResponse.fromJson(Map<String, dynamic> json) {
    return LoanApplicationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? LoanApplicationData.fromJson(json['data']) : null,
    );
  }
}

class LoanApplicationData {
  final String applicationId;
  final String referenceNumber;

  LoanApplicationData({
    required this.applicationId,
    required this.referenceNumber,
  });

  factory LoanApplicationData.fromJson(Map<String, dynamic> json) {
    return LoanApplicationData(
      applicationId: json['application_id'] ?? '',
      referenceNumber: json['reference_number'] ?? '',
    );
  }
}

class DocumentUploadResponse {
  final String status;
  final String message;
  final DocumentUploadData? data;

  DocumentUploadResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? DocumentUploadData.fromJson(json['data']) : null,
    );
  }
}

class DocumentUploadData {
  final String documentType;
  final String fileName;
  final String applicationId;

  DocumentUploadData({
    required this.documentType,
    required this.fileName,
    required this.applicationId,
  });

  factory DocumentUploadData.fromJson(Map<String, dynamic> json) {
    return DocumentUploadData(
      documentType: json['document_type'] ?? '',
      fileName: json['file_name'] ?? '',
      applicationId: json['application_id'] ?? '',
    );
  }
}
