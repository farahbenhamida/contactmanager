import '../../domain/entities/contact.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/api_service.dart';
import '../models/contact_model.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ApiService apiService;

  ContactRepositoryImpl(this.apiService);

  @override
  Future<List<Contact>> getContacts() async {
    final data = await apiService.get('/contacts/');
    return (data as List).map((json) => ContactModel.fromJson(json)).toList();
  }

  @override
  Future<Contact> createContact(String name, String phone, String? email) async {
    final data = await apiService.post('/contacts/', {
      'name': name,
      'phone': phone,
      'email': email,
    });
    return ContactModel.fromJson(data);
  }

  @override
  Future<Contact> updateContact(int id, String name, String phone, String? email) async {
    final data = await apiService.put('/contacts/$id', {
      'name': name,
      'phone': phone,
      'email': email,
    });
    return ContactModel.fromJson(data);
  }

  @override
  Future<void> deleteContact(int id) async {
    await apiService.delete('/contacts/$id');
  }
}
