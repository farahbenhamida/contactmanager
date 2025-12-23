import 'package:flutter/material.dart';

class AppConstants {
  // Use 10.0.2.2 for Android Emulator to access localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
  static const String tokenKey = 'auth_token';
}

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFB00020);
}
