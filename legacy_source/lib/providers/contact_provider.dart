import 'package:flutter/foundation.dart';
import '../models/contact.dart';
import '../services/database_helper.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = false;

  List<Contact> get contacts => _contacts;
  bool get isLoading => _isLoading;

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();
    
    _contacts = await _dbHelper.getContacts();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    await _dbHelper.insertContact(contact);
    await loadContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await _dbHelper.updateContact(contact);
    await loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    await loadContacts();
  }

  Future<List<Contact>> searchContacts(String query) async {
    if (query.isEmpty) return _contacts;
    return await _dbHelper.searchContacts(query);
  }
}