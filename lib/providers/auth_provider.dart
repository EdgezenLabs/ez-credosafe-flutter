import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService api;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;
  User? _user;

  AuthProvider(this.api);

  bool get isLoggedIn => _token != null;
  String? get token => _token;
  User? get user => _user;

  Future<void> loadFromStorage() async {
    _token = await _storage.read(key: 'token');
    // optionally read user info if stored
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final res = await api.login(email, password);
    _token = res['token'];
    if (res['user'] != null) {
      _user = User.fromJson(res['user']);
    }
    await _storage.write(key: 'token', value: _token ?? '');
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}
