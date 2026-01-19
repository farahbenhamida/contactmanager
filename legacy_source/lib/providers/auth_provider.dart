import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  int? _currentUserId;
  String? _currentUserName;
  final ApiService _apiService = ApiService();
  bool get isAuthenticated => _isAuthenticated;
  int? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _currentUserId = prefs.getInt('currentUserId');
    _currentUserName = prefs.getString('currentUserName');
    notifyListeners();
  }
  Future<bool> register(String name, String email, String password) async {
    try {
      final data = await _apiService.register(name, email, password);
      await _setSession(data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> login(String email, String password) async {
    try {
      final data = await _apiService.login(email, password);
      await _setSession(data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<void> _setSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = true;
    _currentUserId = data['user_id'];
    _currentUserName = data['user_name'];
    
    await prefs.setBool('isAuthenticated', true);
    await prefs.setInt('currentUserId', _currentUserId!);
    await prefs.setString('currentUserName', _currentUserName!);
    notifyListeners();
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isAuthenticated = false;
    _currentUserId = null;
    _currentUserName = null;
    notifyListeners();
  }
}