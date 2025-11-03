class Client {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  Client({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory Client.fromJson(Map<String, dynamic> j) => Client(
    id: j['id'] as int?,
    firstName: j['firstName'] ?? '',
    lastName: j['lastName'] ?? '',
    email: j['email'] ?? '',
    phone: j['phone'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
  };
}
