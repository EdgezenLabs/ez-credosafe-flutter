import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';
import '../models/loan_product.dart';
import '../models/application.dart';

class LoansProvider extends ChangeNotifier {
  final ApiService api;
  final AuthProvider auth;

  LoansProvider(this.api, this.auth);

  bool loading = false;
  List<LoanProduct> products = [];
  List<ApplicationModel> myApplications = [];

  Future<void> loadProducts() async {
    loading = true;
    notifyListeners();
    try {
      final list = await api.getLoanProducts(auth.token ?? '');
      products = list.map((e) => LoanProduct.fromJson(e)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMyApplications() async {
    loading = true;
    notifyListeners();
    try {
      final list = await api.getMyApplications(auth.token ?? '');
      myApplications = list.map((e) => ApplicationModel.fromJson(e)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> applyLoan(Map<String, dynamic> form, List files, Function(int,int)? onProgress) async {
    final res = await api.applyLoan(auth.token ?? '', form, List.from(files), onProgress: onProgress);
    return res;
  }
}
