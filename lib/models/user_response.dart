import 'dart:convert';

class UserResponse {
  final String id;
  final String? userName;
  final String? email;

  UserResponse({required this.id, this.userName, this.email});

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    id: json['id'] as String,
    userName: json['userName'] as String?,
    email: json['email'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'email': email,
  };
}
