import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';
class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Use 10.0.2.2 for Android Emulator
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }
  Future<List<Contact>> getContacts(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/contacts?user_id=$userId'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Contact.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }
  Future<Contact> addContact(int userId, Contact contact) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contacts?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact.toJson()),
    );
    if (response.statusCode == 200) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add contact');
    }
  }
  Future<void> deleteContact(int userId, String contactId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/contacts/$contactId?user_id=$userId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete contact');
    }
  }
  Future<Contact> updateContact(int userId, String contactId, Contact contact) async {
    final response = await http.put(
      Uri.parse('$baseUrl/contacts/$contactId?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact.toJson()),
    );
    if (response.statusCode == 200) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update contact');
    }
  }
}