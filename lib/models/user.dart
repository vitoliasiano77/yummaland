class User {
  final int id;
  final String username;
  final String role;
  final String? loginTime; // Nullable

  User({required this.id, required this.username, required this.role, this.loginTime});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      loginTime: json['login_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'login_time': loginTime,
    };
  }
}