class SignInResponse {
  final String token; // JWT
  final List<String> claims; // fx ['Admin', 'User']
  final String? userName;
  final String? email;
  final String? id; // bruger‑id (UUID)

  SignInResponse({
    required this.token,
    this.claims = const [],
    this.userName,
    this.email,
    this.id,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      token: json['token'] as String,
      claims: List<String>.from(json['claims'] ?? <String>[]),
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}
