import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/constants.dart';
import '../models/otp.dart';
import '../utils/logger.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: Constants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final resp = await _dio.post('/auth/login', data: {'email': email, 'password': password});
      return resp.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Send OTP to email
  Future<OtpResponse> sendOtp(String email) async {
    try {
      final request = OtpRequest(email: email);
      final resp = await _dio.post('/auth/send-otp', data: request.toJson());
      return OtpResponse.fromJson(resp.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Verify OTP
  Future<OtpVerificationResponse> verifyOtp(String email, String otp) async {
    try {
      final request = OtpVerificationRequest(email: email, otp: otp);
      final resp = await _dio.post('/auth/verify-otp', data: request.toJson());
      return OtpVerificationResponse.fromJson(resp.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Get loan products
  Future<List> getLoanProducts(String token) async {
    final resp = await _dio.get('/loans', options: Options(headers: {'Authorization': 'Bearer $token'}));
    return resp.data['data'] ?? [];
  }

  // Apply loan - multipart (documents as files)
  Future<Map<String, dynamic>> applyLoan(String token, Map<String, dynamic> form, List<File> files,
      {Function(int, int)? onProgress}) async {
    List<MultipartFile> docs = [];
    for (var f in files) {
      docs.add(await MultipartFile.fromFile(f.path, filename: f.path.split(Platform.pathSeparator).last));
    }

    final formData = FormData.fromMap({
      ...form,
      'documents': docs,
    });

    final resp = await _dio.post('/applications', data: formData, options: Options(headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    }), onSendProgress: onProgress);

    return resp.data;
  }

  // Get my applications
  Future<List> getMyApplications(String token) async {
    final resp = await _dio.get('/applications', options: Options(headers: {'Authorization': 'Bearer $token'}));
    return resp.data['data'] ?? [];
  }

  // (Optional) get application details
  Future<Map<String, dynamic>> getApplication(String token, int id) async {
    final resp = await _dio.get('/applications/$id', options: Options(headers: {'Authorization': 'Bearer $token'}));
    return resp.data;
  }

  // Forgot password - send reset link to email
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final resp = await _dio.post('/auth/forgot-password', data: {'email': email});
      return resp.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Reset password with token
  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    try {
      final resp = await _dio.post('/auth/reset-password', data: {
        'token': token,
        'password': newPassword,
      });
      return resp.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Set password for new user (requires bearer token from verify-otp)
  Future<Map<String, dynamic>> setPassword(String token, String email, String password) async {
    try {
      final resp = await _dio.post('/auth/set-password', 
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return resp.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Get current user profile
  Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      final resp = await _dio.get(
        '/user/profile',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return resp.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Apply for Loan - New API integration
  Future<Map<String, dynamic>> applyForLoan({
    required String token,
    required String loanType,
    required double requestedAmount,
    required String purpose,
    required String employmentType,
    required double monthlyIncome,
    required double existingEmis,
  }) async {
    try {
      final resp = await _dio.post(
        '/loan/apply',
        data: {
          'loan_type': loanType,
          'requested_amount': requestedAmount,
          'purpose': purpose,
          'employment_type': employmentType,
          'monthly_income': monthlyIncome,
          'existing_emis': existingEmis,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return resp.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Upload Application Document
  Future<Map<String, dynamic>> uploadApplicationDocument({
    required String token,
    required String applicationId,
    required String documentType,
    required PlatformFile platformFile,
  }) async {
    try {
      AppLogger.debug('ApiService.uploadApplicationDocument called');
      AppLogger.debug('Application ID: $applicationId');
      AppLogger.debug('Document Type: $documentType');
      AppLogger.debug('Platform: ${kIsWeb ? "Web" : "Mobile/Desktop"}');
      
      MultipartFile multipartFile;
      
      if (kIsWeb) {
        // Web: use bytes (path is not available on web)
        AppLogger.debug('Using bytes for web platform');
        if (platformFile.bytes == null) {
          throw Exception('File bytes are null on web platform');
        }
        multipartFile = MultipartFile.fromBytes(
          platformFile.bytes!,
          filename: platformFile.name,
        );
        AppLogger.debug('Multipart file created from bytes: ${platformFile.name}');
      } else {
        // Mobile/Desktop: use file path
        AppLogger.debug('Using file path for mobile/desktop platform');
        if (platformFile.path == null) {
          throw Exception('File path is null on mobile platform');
        }
        multipartFile = await MultipartFile.fromFile(
          platformFile.path!,
          filename: platformFile.name,
        );
        AppLogger.debug('Multipart file created from path: ${platformFile.path}');
      }

      final formData = FormData.fromMap({
        'document_type': documentType,
        'file': multipartFile,
      });

      AppLogger.debug('Making POST request to: /loan/application/$applicationId/documents');
      final resp = await _dio.post(
        '/loan/application/$applicationId/documents',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      AppLogger.debug('Upload API response status: ${resp.statusCode}');
      AppLogger.debug('Upload API response data: ${resp.data}');
      return resp.data;
    } on DioException catch (e) {
      AppLogger.debug('DioException in uploadApplicationDocument: ${e.message}');
      AppLogger.debug('DioException response: ${e.response?.data}');
      AppLogger.debug('DioException status code: ${e.response?.statusCode}');
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.debug('Generic exception in uploadApplicationDocument: $e');
      rethrow;
    }
  }

  // View Document
  Future<Uint8List?> viewDocument({
    required String token,
    required String documentId,
  }) async {
    try {
      AppLogger.debug('ApiService.viewDocument called');
      AppLogger.debug('Document ID: $documentId');
      final resp = await _dio.get(
        '/loan/document/$documentId/view',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
        ),
      );
      AppLogger.debug('View document API response status: ${resp.statusCode}');
      AppLogger.debug('View document API response data: ${resp.data.runtimeType}');
      return resp.data as Uint8List;
    } on DioException catch (e) {
      AppLogger.debug('DioException in viewDocument: ${e.message}');
      AppLogger.debug('DioException response: ${e.response?.data}');
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.debug('Generic exception in viewDocument: $e');
      rethrow;
    }
  }

  // Download Document
  Future<Uint8List?> downloadDocument({
    required String token,
    required String documentId,
  }) async {
    try {
      AppLogger.debug('ApiService.downloadDocument called');
      AppLogger.debug('Document ID: $documentId');
      final resp = await _dio.get(
        '/loan/document/$documentId/download',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
        ),
      );
      AppLogger.debug('Download document API response status: ${resp.statusCode}');
      AppLogger.debug('Download document API response data: ${resp.data.runtimeType}');
      return resp.data as Uint8List;
    } on DioException catch (e) {
      AppLogger.debug('DioException in downloadDocument: ${e.message}');
      AppLogger.debug('DioException response: ${e.response?.data}');
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.debug('Generic exception in downloadDocument: $e');
      rethrow;
    }
  }

  // Get Loan Details
  Future<Map<String, dynamic>> getLoanDetails({
    required String token,
    required String loanId,
  }) async {
    try {
      final resp = await _dio.get(
        '/loan/details/$loanId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return resp.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Cancel Loan Application
  Future<Map<String, dynamic>> cancelLoanApplication({
    required String token,
    required String applicationId,
  }) async {
    try {
      final resp = await _dio.put(
        '/loan/application/$applicationId/cancel',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return resp.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Process Loan Payment
  Future<Map<String, dynamic>> processLoanPayment({
    required String token,
    required String loanId,
    required double paymentAmount,
    required String paymentMethod,
    required String paymentReference,
  }) async {
    try {
      final resp = await _dio.post(
        '/loan/payment',
        data: {
          'loan_id': loanId,
          'payment_amount': paymentAmount,
          'payment_method': paymentMethod,
          'payment_reference': paymentReference,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return resp.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Private helper method for handling Dio exceptions
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Request timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'Server error occurred';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.connectionError:
        return Exception('Connection failed. Please check your internet connection.');
      default:
        return Exception('An unexpected error occurred: ${e.message}');
    }
  }
}
