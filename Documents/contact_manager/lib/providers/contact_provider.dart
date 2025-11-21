import 'package:flutter/foundation.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class ContactProvider with ChangeNotifier {
  final ContactService _contactService = ContactService();
  List<Contact> _contacts = [];
  bool _isLoading = false;
  String? _searchQuery;

  List<Contact> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get searchQuery => _searchQuery;

  List<Contact> get filteredContacts {
    if (_searchQuery == null || _searchQuery!.isEmpty) {
      return _contacts;
    }
    return _contacts.where((contact) {
      return contact.fullName.toLowerCase().contains(_searchQuery!.toLowerCase()) ||
          contact.phoneNumber.contains(_searchQuery!) ||
          (contact.email?.toLowerCase().contains(_searchQuery!.toLowerCase()) ?? false);
    }).toList();
  }

  ContactProvider() {
    loadContacts();
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();

    _contacts = await _contactService.getContacts();
    
    // Si pas de contacts, ajouter des exemples
    if (_contacts.isEmpty) {
      await _addSampleContacts();
      _contacts = await _contactService.getContacts();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _addSampleContacts() async {
    final sampleContacts = [
      Contact(
        firstName: 'Farah',
        lastName: 'Ben Hamida',
        phoneNumber: '12345678',
        email: 'farah@email.com',
        address: 'Tunis, Tunisia',
      ),
      Contact(
        firstName: 'Ahmed',
        lastName: 'Smith',
        phoneNumber: '87654321',
        email: 'ahmed@email.com',
        address: 'Sfax, Tunisia',
      ),
      Contact(
        firstName: 'Sarah',
        lastName: 'Johnson',
        phoneNumber: '55555555',
        email: 'sarah@email.com',
        address: 'Sousse, Tunisia',
      ),
    ];

    for (final contact in sampleContacts) {
      await _contactService.addContact(contact);
    }
  }

  Future<void> addContact(Contact contact) async {
    await _contactService.addContact(contact);
    await loadContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await _contactService.updateContact(contact);
    await loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await _contactService.deleteContact(id);
    await loadContacts();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = null;
    notifyListeners();
  }
}