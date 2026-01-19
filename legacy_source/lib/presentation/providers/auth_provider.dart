import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../data/datasources/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final token = await _apiService.login(email, password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> register(String email, String password, String name) async {
    await _apiService.register(email, password, name);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    _isAuthenticated = false;
    notifyListeners();
  }
}
