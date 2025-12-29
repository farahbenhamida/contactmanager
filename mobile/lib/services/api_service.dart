import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<Person>> getPersons() async {
    final response = await http.get(Uri.parse('$baseUrl/personnes'));
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Person.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des personnes');
    }
  }

  static Future<String> addPerson(Person person) async {
    final response = await http.post(
      Uri.parse('$baseUrl/personnes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(person.toJson()),
    );

    if (response.statusCode == 200) {
      return 'Personne ajoutée avec succès';
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail'] ?? 'Erreur lors de l\'ajout');
    }
  }

  static Future<String> deletePerson(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/personnes/$id'),
    );

    if (response.statusCode == 200) {
      return 'Personne supprimée avec succès';
    } else {
      throw Exception('Erreur lors de la suppression');
    }
  }
}
