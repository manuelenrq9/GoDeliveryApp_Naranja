class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      profileImageUrl: json['profileImageUrl'] ??
          'https://covalto-production-website.s3.amazonaws.com/Hero_Mobile_Cuenta_Personas_V1_1_8046e424ea.webp',
    );
  }
}
