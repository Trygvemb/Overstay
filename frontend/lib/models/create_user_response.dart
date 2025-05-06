//

class CreateUserResponse {
  final String token; // JWT
  final List<String> claims; // fx ['User']
  final String userName;
  final String email;

  CreateUserResponse({
    required this.token,
    required this.claims,
    required this.userName,
    required this.email,
  });

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) {
    return CreateUserResponse(
      token: json['token'] as String,
      claims: List<String>.from(json['claims'] ?? <String>[]),
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}
