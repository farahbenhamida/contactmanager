import 'package:flutter/material.dart';
import '../../domain/entities/contact.dart';
import '../../data/repositories/contact_repository_impl.dart';
import '../../data/datasources/api_service.dart';

class ContactProvider with ChangeNotifier {
  final ContactRepositoryImpl _repository = ContactRepositoryImpl(ApiService());
  List<Contact> _contacts = [];
  bool _isLoading = false;

  List<Contact> get contacts => _contacts;
  bool get isLoading => _isLoading;

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _contacts = await _repository.getContacts();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addContact(String name, String phone, String? email) async {
    await _repository.createContact(name, phone, email);
    await loadContacts();
  }

  Future<void> updateContact(int id, String name, String phone, String? email) async {
    await _repository.updateContact(id, name, phone, email);
    await loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await _repository.deleteContact(id);
    await loadContacts();
  }
}
