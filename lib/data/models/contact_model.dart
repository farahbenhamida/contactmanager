import '../../domain/entities/contact.dart';

class ContactModel extends Contact {
  ContactModel({required super.id, required super.name, required super.phone, super.email});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}
