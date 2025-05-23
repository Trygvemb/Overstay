
class SignInUserRequest {
  final String userName;
  final String password;

  SignInUserRequest({required this.userName, required this.password});

  Map<String, dynamic> toJson() => {'userName': userName, 'password': password};
}
