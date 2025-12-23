import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

class ApiService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('${AppConstants.baseUrl}$endpoint'), headers: headers);
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Failed to load data: ${response.statusCode}');
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) return json.decode(response.body);
    throw Exception('Failed to post data: ${response.statusCode} ${response.body}');
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Failed to update data');
  }

  Future<void> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('${AppConstants.baseUrl}$endpoint'), headers: headers);
    if (response.statusCode != 200) throw Exception('Failed to delete data');
  }

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': email, 'password': password},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    }
    throw Exception('Login failed');
  }

  Future<void> register(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password, 'name': name}),
    );
    if (response.statusCode != 200) throw Exception('Registration failed');
  }
}
