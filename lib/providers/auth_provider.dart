import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../models/otp.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService api;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this.api);

  bool get isLoggedIn => _token != null;
  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> loadFromStorage() async {
    _token = await _storage.read(key: 'token');
    // optionally read user info if stored
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final res = await api.login(email, password);
      _token = res['token'];
      if (res['user'] != null) {
        _user = User.fromJson(res['user']);
      }
      await _storage.write(key: 'token', value: _token ?? '');
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Send OTP to the provided email address
  Future<OtpResponse> sendOtp(String email) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await api.sendOtp(email);
      return response;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Verify OTP and complete authentication
  Future<OtpVerificationResponse> verifyOtp(String email, String otp) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await api.verifyOtp(email, otp);
      
      // If verification is successful and contains token, log the user in
      if (response.success && response.token != null) {
        _token = response.token;
        if (response.user != null) {
          _user = User.fromJson(response.user!);
        }
        await _storage.write(key: 'token', value: _token ?? '');
        notifyListeners();
      }
      
      return response;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Send password reset link to email
  Future<void> forgotPassword(String email) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await api.forgotPassword(email);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password with token
  Future<void> resetPassword(String token, String newPassword) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await api.resetPassword(token, newPassword);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}
