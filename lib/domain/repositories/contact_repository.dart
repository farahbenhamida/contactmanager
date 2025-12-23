import '../entities/contact.dart';

abstract class ContactRepository {
  Future<List<Contact>> getContacts();
  Future<Contact> createContact(String name, String phone, String? email);
  Future<Contact> updateContact(int id, String name, String phone, String? email);
  Future<void> deleteContact(int id);
}
