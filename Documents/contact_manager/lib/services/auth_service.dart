import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';

  Future<User?> login(String email, String password) async {
    // Simulation d'un délai réseau
    await Future.delayed(const Duration(seconds: 1));

    // Vérification des identifiants de démonstration
    if (email == 'admin@example.com' && password == 'password') {
      final user = User(
        id: 1,
        name: 'Admin User',
        email: email,
        token: 'mock_jwt_token_12345',
      );
      
      await _saveUser(user);
      return user;
    } else {
      throw Exception('Email ou mot de passe incorrect');
    }
  }

  Future<User?> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      email: email,
      token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
    );
    
    await _saveUser(user);
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        final userMap = jsonDecode(userJson);
        return User.fromJson(userMap);
      }
    } catch (e) {
      print('Erreur lors du chargement de l\'utilisateur: $e');
    }
    
    return null;
  }

  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}

// Fonctions d'encodage/décodage JSON locales
String jsonEncode(Map<String, dynamic> map) {
  final buffer = StringBuffer();
  buffer.write('{');
  map.entries.forEach((entry) {
    buffer.write('"${entry.key}":');
    if (entry.value is String) {
      buffer.write('"${entry.value}"');
    } else {
      buffer.write(entry.value);
    }
    buffer.write(',');
  });
  buffer.write('}');
  return buffer.toString().replaceAll(',}', '}');
}

Map<String, dynamic> jsonDecode(String jsonString) {
  final map = <String, dynamic>{};
  final cleanString = jsonString.replaceAll('{', '').replaceAll('}', '');
  final pairs = cleanString.split(',');
  
  for (final pair in pairs) {
    final keyValue = pair.split(':');
    if (keyValue.length == 2) {
      var key = keyValue[0].trim().replaceAll('"', '');
      var value = keyValue[1].trim().replaceAll('"', '');
      
      // Conversion des nombres
      if (key == 'id' && int.tryParse(value) != null) {
        map[key] = int.parse(value);
      } else {
        map[key] = value;
      }
    }
  }
  
  return map;
}