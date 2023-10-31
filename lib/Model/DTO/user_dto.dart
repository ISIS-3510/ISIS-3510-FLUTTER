class UserDTO {
  const UserDTO({
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
    required this.username,
    required this.degree,
  });

  final String email;
  final String name;
  final String password;
  final String phone;
  final String username;
  final String degree;

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "username": username,
      "degree": degree,
    };
  }
}
