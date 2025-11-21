import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../services/database_helper.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  bool _isLoading = false;

  List<Contact> get contacts => _contacts;
  bool get isLoading => _isLoading;

  ContactProvider() {
    loadContacts();
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _contacts = await DatabaseHelper().getContacts();
    } catch (error) {
      debugPrint('Error loading contacts: $error');

      _contacts = [
        Contact(id: 1, name: 'Farah', phone: '12345678', email: 'farah@email.com'),
        Contact(id: 2, name: 'Ahmed', phone: '87654321', email: 'ahmed@email.com'),
      ];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addContact(Contact contact) async {
    try {
      await DatabaseHelper().insertContact(contact);
      await loadContacts();
    } catch (error) {
      debugPrint('Error adding contact: $error');
      final newContact = contact.copyWith(id: _contacts.length + 1);
      _contacts.add(newContact);
      notifyListeners();
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      await DatabaseHelper().updateContact(contact);
      await loadContacts();
    } catch (error) {
      debugPrint('Error updating contact: $error');
      rethrow;
    }
  }

  Future<void> deleteContact(int id) async {
    try {
      await DatabaseHelper().deleteContact(id);
      _contacts.removeWhere((contact) => contact.id == id);
      notifyListeners();
    } catch (error) {
      debugPrint('Error deleting contact: $error');
      rethrow;
    }
  }
}