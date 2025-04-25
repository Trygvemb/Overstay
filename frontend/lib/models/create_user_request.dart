import 'dart:convert';

class CreateUserRequest {
  final String userName;
  final String email;
  final String password;
  final String? countryId; // kan være null

  CreateUserRequest({
    required this.userName,
    required this.email,
    required this.password,
    this.countryId,
  });

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'email': email,
    'password': password,
    'countryId': countryId,
  };
}
