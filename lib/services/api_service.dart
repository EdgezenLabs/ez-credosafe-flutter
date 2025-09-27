import 'dart:io';
import 'package:dio/dio.dart';
import '../config/constants.dart';

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
}
