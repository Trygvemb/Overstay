// lib/models/user_response.dart
class UserResponse {
  final String id; // bruger‑id (UUID)
  final String userName;
  final String email;
  final List<String> roles; // kan være tom

  UserResponse({
    required this.id,
    required this.userName,
    required this.email,
    required this.roles,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String,
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      roles: List<String>.from(json['roles'] ?? <String>[]),
    );
  }
}
