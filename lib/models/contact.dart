class Contact {
  final int? id;
  final String name;
  final String phone;
  final String? email;
  final String? address;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      address: map['address'],
    );
  }

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}