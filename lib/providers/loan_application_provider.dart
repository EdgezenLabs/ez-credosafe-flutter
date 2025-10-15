import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';
import '../models/loan_application.dart';

class LoanApplicationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String? _error;
  LoanApplicationResponse? _applicationResponse;
  String? _currentApplicationId;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  LoanApplicationResponse? get applicationResponse => _applicationResponse;
  String? get currentApplicationId => _currentApplicationId;

  // Apply for loan
  Future<bool> applyForLoan({
    required String token,
    required String loanType,
    required double requestedAmount,
    required String purpose,
    required String employmentType,
    required double monthlyIncome,
    required double existingEmis,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.applyForLoan(
        token: token,
        loanType: loanType,
        requestedAmount: requestedAmount,
        purpose: purpose,
        employmentType: employmentType,
        monthlyIncome: monthlyIncome,
        existingEmis: existingEmis,
      );

      _applicationResponse = LoanApplicationResponse.fromJson(response);
      _currentApplicationId = _applicationResponse?.data?.applicationId;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Upload document
  Future<bool> uploadDocument({
    required String token,
    required String applicationId,
    required String documentType,
    required PlatformFile file,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.uploadApplicationDocument(
        token: token,
        applicationId: applicationId,
        documentType: documentType,
        platformFile: file, // Pass PlatformFile directly
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset state
  void reset() {
    _isLoading = false;
    _error = null;
    _applicationResponse = null;
    _currentApplicationId = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
