import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../models/otp.dart';
import '../utils/logger.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService api;
  final FlutterSecureStorage _storage;
  String? _token;
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this.api, {FlutterSecureStorage? storage}) 
      : _storage = storage ?? const FlutterSecureStorage();

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
      
      // Debug logging to help troubleshoot
      AppLogger.debug('Login API response: $res');
      
      // Handle the correct API response structure
      _token = res['access_token'] ?? res['token']; // Try both field names for compatibility
      
      if (_token == null || _token!.isEmpty) {
        throw Exception('No authentication token received from server');
      }
      
      AppLogger.debug('Token extracted: $_token');
      
      if (res['user'] != null) {
        _user = User.fromJson(res['user']);
        AppLogger.debug('User data parsed: ${_user?.email}');
      }
      
      await _storage.write(key: 'token', value: _token!);
      notifyListeners();
      
      AppLogger.info('Login successful for user: $email');
    } catch (e) {
      AppLogger.error('Login failed for user: $email', e);
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

  /// Set password for new user (requires bearer token from verify-otp)
  Future<void> setPassword(String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      if (_token == null) {
        throw Exception('No authentication token available. Please verify OTP first.');
      }
      
      await api.setPassword(_token!, email, password);
      
      // The password setup is successful, user is now fully authenticated
      // The token should remain the same from OTP verification
      notifyListeners();
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
