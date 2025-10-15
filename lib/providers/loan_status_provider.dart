import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../config/constants.dart';
import '../models/loan_status.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class LoanStatusProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  
  LoanStatus? _loanStatus;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticationError = false;
  bool _hasDataLoaded = false; // Flag to prevent multiple API calls

  LoanStatus? get loanStatus => _loanStatus;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticationError => _isAuthenticationError;
  bool get hasDataLoaded => _hasDataLoaded;

  Future<void> fetchLoanStatus(AuthProvider authProvider, {bool forceRefresh = false}) async {
    // Prevent multiple API calls unless forced refresh
    if (_hasDataLoaded && !forceRefresh) {
      print('Loan status already loaded, skipping API call');
      return;
    }

    _isLoading = true;
    _error = null;
    _isAuthenticationError = false;
    notifyListeners();

    try {
      // Get the auth token from AuthProvider
      final token = authProvider.token;
      
      if (token == null || token.isEmpty) {
        _isAuthenticationError = true;
        _error = 'No authentication token found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      print('Making loan status API call to: ${AppConstants.baseUrl}/user/loan-status');
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/user/loan-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Loan status API response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Handle the response format: {"status": "success", "data": {...}}
        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          final data = jsonData['data'];
          
          // If user is new_user and no loan_types provided, add sample loan types
          if (data['user_status'] == 'new_user' && data['loan_types'] == null) {
            data['loan_types'] = _getSampleLoanTypes();
          }
          
          _loanStatus = LoanStatus.fromJson(data);
          _hasDataLoaded = true;
          _isAuthenticationError = false;
          print('Loan status loaded successfully: ${_loanStatus?.userStatus}');
        } else {
          _error = 'Invalid response format';
          print('Invalid response format: $jsonData');
        }
      } else if (response.statusCode == 401) {
        // Authentication failed - token is invalid or expired
        _isAuthenticationError = true;
        _error = 'Authentication failed. Please login again.';
        print('Authentication error: ${response.body}');
        
        // Logout the user
        await authProvider.logout();
      } else {
        _error = 'Failed to fetch loan status: ${response.statusCode}';
        print('Error response: ${response.body}');
      }
    } catch (e) {
      _error = 'Network error: $e';
      print('Exception in fetchLoanStatus: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> applyForLoan({
    required String loanType,
    required double amount,
    required int tenure,
    required AuthProvider authProvider,
  }) async {
    try {
      final token = authProvider.token;
      if (token == null || token.isEmpty) {
        print('No authentication token for loan application');
        return null;
      }

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/loan/apply'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'loan_type': loanType,
          'amount': amount,
          'tenure': tenure,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        // Authentication failed
        await authProvider.logout();
        return null;
      } else {
        print('Error applying for loan: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in applyForLoan: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadDocument({
    required String token,
    required String applicationId,
    required String documentType,
    required PlatformFile file,
  }) async {
    try {
      print('LoanStatusProvider.uploadDocument called');
      print('Application ID: $applicationId');
      print('Document Type: $documentType');
      print('File name: ${file.name}');
      print('File size: ${file.size}');
      
      final response = await apiService.uploadApplicationDocument(
        token: token,
        applicationId: applicationId,
        documentType: documentType,
        platformFile: file,
      );
      
      print('Upload successful, response: $response');
      return response;
    } catch (e) {
      print('Exception in LoanStatusProvider.uploadDocument: $e');
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<String?> viewDocument({
    required String token,
    required String documentId,
  }) async {
    try {
      print('LoanStatusProvider.viewDocument called');
      print('Document ID: $documentId');
      
      final url = await apiService.viewDocument(
        token: token,
        documentId: documentId,
      );
      
      print('View document successful, URL: $url');
      return url;
    } catch (e) {
      print('Exception in LoanStatusProvider.viewDocument: $e');
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<String?> downloadDocument({
    required String token,
    required String documentId,
  }) async {
    try {
      print('LoanStatusProvider.downloadDocument called');
      print('Document ID: $documentId');
      
      final url = await apiService.downloadDocument(
        token: token,
        documentId: documentId,
      );
      
      print('Download document successful, URL: $url');
      return url;
    } catch (e) {
      print('Exception in LoanStatusProvider.downloadDocument: $e');
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> getApplicationDetails(String applicationId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/loan/application/$applicationId'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error fetching application details: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in getApplicationDetails: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getLoanDetails(String loanId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/loan/details/$loanId'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error fetching loan details: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in getLoanDetails: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> makePayment({
    required String loanId,
    required double amount,
    required String paymentMethod,
    required AuthProvider authProvider,
  }) async {
    try {
      final token = authProvider.token;
      if (token == null || token.isEmpty) {
        print('No authentication token for payment');
        return null;
      }

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/loan/payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'loan_id': loanId,
          'amount': amount,
          'payment_method': paymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        // Authentication failed
        await authProvider.logout();
        return null;
      } else {
        print('Error making payment: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in makePayment: $e');
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _loanStatus = null;
    _isLoading = false;
    _error = null;
    _isAuthenticationError = false;
    _hasDataLoaded = false; // Reset the flag so API can be called again
    notifyListeners();
  }

  // Method to force refresh the loan status
  Future<void> refreshLoanStatus(AuthProvider authProvider) async {
    await fetchLoanStatus(authProvider, forceRefresh: true);
  }

  // Sample loan types for new users
  List<Map<String, dynamic>> _getSampleLoanTypes() {
    return [
      {
        "id": "personal",
        "name": "Personal Loan",
        "description": "Quick and flexible personal loans for your immediate needs",
        "min_amount": 50000,
        "max_amount": 1000000,
        "interest_rate": 12.5,
        "max_tenure": 60,
        "eligibility_criteria": [
          "Age between 21-65 years",
          "Minimum salary ₹25,000 per month",
          "Good credit score (650+)",
          "Stable employment history"
        ],
        "required_documents": [
          "Aadhaar Card",
          "PAN Card",
          "Salary Slips (3 months)",
          "Bank Statements (6 months)"
        ]
      },
      {
        "id": "business",
        "name": "Business Loan",
        "description": "Grow your business with our competitive business loans",
        "min_amount": 100000,
        "max_amount": 5000000,
        "interest_rate": 14.0,
        "max_tenure": 84,
        "eligibility_criteria": [
          "Business vintage of 2+ years",
          "Annual turnover ₹10 lakh+",
          "Good business credit history",
          "Valid business registration"
        ],
        "required_documents": [
          "Business Registration Certificate",
          "GST Registration",
          "Income Tax Returns (2 years)",
          "Bank Statements (12 months)",
          "Financial Statements"
        ]
      },
      {
        "id": "home",
        "name": "Home Loan",
        "description": "Make your dream home a reality with our home loans",
        "min_amount": 500000,
        "max_amount": 10000000,
        "interest_rate": 8.5,
        "max_tenure": 240,
        "eligibility_criteria": [
          "Age between 21-65 years",
          "Stable income source",
          "Good credit score (700+)",
          "Property documents verified"
        ],
        "required_documents": [
          "Property Documents",
          "Income Proof",
          "Identity & Address Proof",
          "Bank Statements (6 months)",
          "Property Valuation Report"
        ]
      },
      {
        "id": "car",
        "name": "Car Loan",
        "description": "Drive your dream car with our affordable car loans",
        "min_amount": 200000,
        "max_amount": 2000000,
        "interest_rate": 9.5,
        "max_tenure": 84,
        "eligibility_criteria": [
          "Age between 21-65 years",
          "Stable income source",
          "Good credit score (650+)",
          "Valid driving license"
        ],
        "required_documents": [
          "Income Proof",
          "Identity & Address Proof",
          "Bank Statements (3 months)",
          "Car Quotation/Invoice",
          "Driving License"
        ]
      }
    ];
  }

  // Cancel loan application
  Future<void> cancelLoanApplication(String token, String applicationId, AuthProvider authProvider) async {
    try {
      print('Cancelling loan application: $applicationId');
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}/loan/application/$applicationId/cancel'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Cancel response status: ${response.statusCode}');
      print('Cancel response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Loan application cancelled successfully: ${data['message']}');
        
        // Force refresh loan status from API to get updated list
        await fetchLoanStatus(authProvider, forceRefresh: true);
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['message'] ?? 'Failed to cancel application';
        notifyListeners();
        throw Exception(_error);
      }
    } catch (e) {
      print('Error cancelling loan application: $e');
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}