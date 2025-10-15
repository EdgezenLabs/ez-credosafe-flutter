class LoanStatus {
  final String userStatus;
  final LoanDetails? loanDetails;
  final PendingApplication? pendingApplication;
  final List<PendingApplication>? pendingApplications;
  final List<LoanType>? loanTypes;

  LoanStatus({
    required this.userStatus,
    this.loanDetails,
    this.pendingApplication,
    this.pendingApplications,
    this.loanTypes,
  });

  factory LoanStatus.fromJson(Map<String, dynamic> json) {
    return LoanStatus(
      userStatus: json['user_status'] ?? '',
      loanDetails: json['loan_details'] != null
          ? LoanDetails.fromJson(json['loan_details'])
          : null,
      pendingApplication: json['pending_application'] != null
          ? PendingApplication.fromJson(json['pending_application'])
          : null,
      pendingApplications: json['pending_applications'] != null
          ? (json['pending_applications'] as List)
              .map((x) => PendingApplication.fromJson(x))
              .toList()
          : null,
      loanTypes: json['loan_types'] != null
          ? (json['loan_types'] as List)
              .map((x) => LoanType.fromJson(x))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_status': userStatus,
      'loan_details': loanDetails?.toJson(),
      'pending_application': pendingApplication?.toJson(),
      'pending_applications': pendingApplications?.map((x) => x.toJson()).toList(),
      'loan_types': loanTypes?.map((x) => x.toJson()).toList(),
    };
  }
}

class LoanDetails {
  final String loanId;
  final String loanType;
  final double loanAmount;
  final double interestRate;
  final int tenure;
  final String status;
  final double monthlyEmi;
  final double outstandingAmount;
  final String nextDueDate;
  final String loanStartDate;
  final String loanEndDate;

  LoanDetails({
    required this.loanId,
    required this.loanType,
    required this.loanAmount,
    required this.interestRate,
    required this.tenure,
    required this.status,
    required this.monthlyEmi,
    required this.outstandingAmount,
    required this.nextDueDate,
    required this.loanStartDate,
    required this.loanEndDate,
  });

  factory LoanDetails.fromJson(Map<String, dynamic> json) {
    return LoanDetails(
      loanId: json['loan_id'] ?? '',
      loanType: json['loan_type'] ?? '',
      loanAmount: (json['loan_amount'] ?? 0).toDouble(),
      interestRate: (json['interest_rate'] ?? 0).toDouble(),
      tenure: json['tenure'] ?? 0,
      status: json['status'] ?? '',
      monthlyEmi: (json['monthly_emi'] ?? 0).toDouble(),
      outstandingAmount: (json['outstanding_amount'] ?? 0).toDouble(),
      nextDueDate: json['next_due_date'] ?? '',
      loanStartDate: json['loan_start_date'] ?? '',
      loanEndDate: json['loan_end_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loan_id': loanId,
      'loan_type': loanType,
      'loan_amount': loanAmount,
      'interest_rate': interestRate,
      'tenure': tenure,
      'status': status,
      'monthly_emi': monthlyEmi,
      'outstanding_amount': outstandingAmount,
      'next_due_date': nextDueDate,
      'loan_start_date': loanStartDate,
      'loan_end_date': loanEndDate,
    };
  }
}

class PendingApplication {
  final String applicationId;
  final String loanType;
  final double requestedAmount;
  final String status;
  final String submittedDate;
  final String? applicationDate;
  final int? currentStep;
  final List<String>? progressSteps;
  final List<String> documentsSubmitted;
  final List<String> documentsRequired;
  final List<LoanDocument>? documents; // Store full document objects
  final String? rejectionReason;

  PendingApplication({
    required this.applicationId,
    required this.loanType,
    required this.requestedAmount,
    required this.status,
    required this.submittedDate,
    this.applicationDate,
    this.currentStep,
    this.progressSteps,
    required this.documentsSubmitted,
    required this.documentsRequired,
    this.documents,
    this.rejectionReason,
  });

  factory PendingApplication.fromJson(Map<String, dynamic> json) {
    // Handle documents_required which can be either array of strings or array of objects
    List<String> docRequired = [];
    if (json['documents_required'] != null) {
      if (json['documents_required'] is List) {
        for (var item in json['documents_required']) {
          if (item is String) {
            docRequired.add(item);
          } else if (item is Map) {
            // If it's an object, extract the document_type
            docRequired.add(item['document_type']?.toString() ?? '');
          }
        }
      }
    }

    // Handle documents_submitted which can be either array of strings or array of objects
    List<String> docSubmitted = [];
    if (json['documents_submitted'] != null) {
      if (json['documents_submitted'] is List) {
        for (var item in json['documents_submitted']) {
          if (item is String) {
            docSubmitted.add(item);
          } else if (item is Map) {
            docSubmitted.add(item['document_type']?.toString() ?? '');
          }
        }
      }
    } else if (json['documents'] != null) {
      // Handle 'documents' array if present
      if (json['documents'] is List) {
        for (var item in json['documents']) {
          if (item is Map) {
            docSubmitted.add(item['document_type']?.toString() ?? '');
          }
        }
      }
    }

    // Parse documents array
    List<LoanDocument>? docs;
    if (json['documents'] != null && json['documents'] is List) {
      docs = (json['documents'] as List)
          .map((doc) => LoanDocument.fromJson(doc))
          .toList();
    }

    return PendingApplication(
      applicationId: json['application_id'] ?? '',
      loanType: json['loan_type'] ?? '',
      requestedAmount: double.parse((json['requested_amount'] ?? 0).toString()),
      status: json['status'] ?? '',
      submittedDate: json['submitted_date'] ?? json['application_date'] ?? '',
      applicationDate: json['application_date'],
      currentStep: json['current_step'],
      progressSteps: json['progress_steps'] != null 
          ? List<String>.from(json['progress_steps']) 
          : null,
      documentsSubmitted: docSubmitted,
      documentsRequired: docRequired,
      documents: docs,
      rejectionReason: json['rejection_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'loan_type': loanType,
      'requested_amount': requestedAmount,
      'status': status,
      'submitted_date': submittedDate,
      'application_date': applicationDate,
      'current_step': currentStep,
      'progress_steps': progressSteps,
      'documents_submitted': documentsSubmitted,
      'documents_required': documentsRequired,
      'documents': documents?.map((x) => x.toJson()).toList(),
      'rejection_reason': rejectionReason,
    };
  }
}

class LoanType {
  final String id;
  final String name;
  final String description;
  final double minAmount;
  final double maxAmount;
  final double interestRate;
  final int maxTenure;
  final List<String> eligibilityCriteria;
  final List<String> requiredDocuments;

  LoanType({
    required this.id,
    required this.name,
    required this.description,
    required this.minAmount,
    required this.maxAmount,
    required this.interestRate,
    required this.maxTenure,
    required this.eligibilityCriteria,
    required this.requiredDocuments,
  });

  factory LoanType.fromJson(Map<String, dynamic> json) {
    return LoanType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      minAmount: (json['min_amount'] ?? 0).toDouble(),
      maxAmount: (json['max_amount'] ?? 0).toDouble(),
      interestRate: (json['interest_rate'] ?? 0).toDouble(),
      maxTenure: json['max_tenure'] ?? 0,
      eligibilityCriteria: List<String>.from(json['eligibility_criteria'] ?? []),
      requiredDocuments: List<String>.from(json['required_documents'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'interest_rate': interestRate,
      'max_tenure': maxTenure,
      'eligibility_criteria': eligibilityCriteria,
      'required_documents': requiredDocuments,
    };
  }
}

class LoanDocument {
  final String documentId;
  final String documentType;
  final String fileName;
  final String filePath;
  final String status;
  final String uploadedAt;

  LoanDocument({
    required this.documentId,
    required this.documentType,
    required this.fileName,
    required this.filePath,
    required this.status,
    required this.uploadedAt,
  });

  factory LoanDocument.fromJson(Map<String, dynamic> json) {
    return LoanDocument(
      documentId: json['document_id'] ?? '',
      documentType: json['document_type'] ?? '',
      fileName: json['file_name'] ?? '',
      filePath: json['file_path'] ?? '',
      status: json['status'] ?? '',
      uploadedAt: json['uploaded_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'document_type': documentType,
      'file_name': fileName,
      'file_path': filePath,
      'status': status,
      'uploaded_at': uploadedAt,
    };
  }
}
