import 'dart:io';
import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../models/otp.dart';

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
    final resp = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    return resp.data;
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
