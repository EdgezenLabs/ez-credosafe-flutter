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
  
  // Role-based access control
  bool get isCustomer => _user?.role == 'customer';
  bool get hasLoanAccess => isCustomer; // Only customers have loan access
  String get displayName => _user?.name ?? 'User';

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
    try {
      _token = await _storage.read(key: 'token');
      
      // Load user data from storage
      final userId = await _storage.read(key: 'user_id');
      final userEmail = await _storage.read(key: 'user_email');
      final userName = await _storage.read(key: 'user_name');
      final userPhone = await _storage.read(key: 'user_phone');
      final userRole = await _storage.read(key: 'user_role');
      final userIsActive = await _storage.read(key: 'user_is_active');
      final userTenantId = await _storage.read(key: 'user_tenant_id');
      final userCreatedAt = await _storage.read(key: 'user_created_at');
      
      if (userId != null && userEmail != null && userName != null) {
        _user = User(
          id: userId,
          email: userEmail,
          name: userName,
          phone: userPhone,
          role: userRole ?? 'customer',
          isActive: userIsActive == 'true',
          tenantId: userTenantId,
          createdAt: userCreatedAt ?? '',
        );
        AppLogger.info('User data loaded from storage: ${_user?.email}');
      }
      
      if (_token != null) {
        AppLogger.info('Token loaded from storage');
      }
      
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error loading from storage', e);
    }
  }

  Future<void> _saveUserToStorage(User user) async {
    try {
      await _storage.write(key: 'user_id', value: user.id);
      await _storage.write(key: 'user_email', value: user.email);
      await _storage.write(key: 'user_name', value: user.name);
      await _storage.write(key: 'user_phone', value: user.phone ?? '');
      await _storage.write(key: 'user_role', value: user.role);
      await _storage.write(key: 'user_is_active', value: user.isActive.toString());
      await _storage.write(key: 'user_tenant_id', value: user.tenantId ?? '');
      await _storage.write(key: 'user_created_at', value: user.createdAt);
      AppLogger.debug('User data saved to storage');
    } catch (e) {
      AppLogger.error('Error saving user to storage', e);
    }
  }

  Future<void> _clearUserFromStorage() async {
    try {
      await _storage.delete(key: 'user_id');
      await _storage.delete(key: 'user_email');
      await _storage.delete(key: 'user_name');
      await _storage.delete(key: 'user_phone');
      await _storage.delete(key: 'user_role');
      await _storage.delete(key: 'user_is_active');
      await _storage.delete(key: 'user_tenant_id');
      await _storage.delete(key: 'user_created_at');
      AppLogger.debug('User data cleared from storage');
    } catch (e) {
      AppLogger.error('Error clearing user from storage', e);
    }
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
        // Save user data to secure storage
        await _saveUserToStorage(_user!);
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
          // Save user data to secure storage
          await _saveUserToStorage(_user!);
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

  /// Fetch current user profile from API
  Future<void> fetchUserProfile() async {
    if (_token == null) {
      AppLogger.warning('Cannot fetch user profile: No token available');
      return;
    }

    try {
      final response = await api.getUserProfile(_token!);
      
      if (response['user'] != null) {
        _user = User.fromJson(response['user']);
        await _saveUserToStorage(_user!);
        AppLogger.info('User profile updated: ${_user?.email}');
        notifyListeners();
      } else if (response['id'] != null) {
        // If the response is the user object itself
        _user = User.fromJson(response);
        await _saveUserToStorage(_user!);
        AppLogger.info('User profile updated: ${_user?.email}');
        notifyListeners();
      }
    } catch (e) {
      AppLogger.error('Failed to fetch user profile', e);
      // Don't throw, just log - this is a non-critical operation
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.delete(key: 'token');
    await _clearUserFromStorage();
    AppLogger.info('User logged out successfully');
    notifyListeners();
  }
}

