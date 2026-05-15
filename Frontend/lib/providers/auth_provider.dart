import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.login(email, password);
      _user = response.user;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String fullName, {String role = 'User'}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.register(email, password, fullName, role: role);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    notifyListeners();
  }

  // Try to auto login if token exists
  Future<void> tryAutoLogin() async {
    final token = await _apiService.getToken();
    if (token != null) {
      // In a real app, you might want to fetch the user profile from the API
      // For now, we'll just assume it's valid if we have it
      // or decode it to get basic info
    }
  }
}
