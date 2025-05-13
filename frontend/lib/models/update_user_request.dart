/// Payload til PUT /api/User/{id}
class UpdateUserRequest {
  final String? userName;
  final String? email;
  final String? country;
  final String? password; // sendes kun hvis udfyldt

  UpdateUserRequest({this.userName, this.email, this.country, this.password});

  /// konverter til JSON – tomme felter udelades
  Map<String, dynamic> toJson() => {
    if (userName != null) 'userName': userName,
    if (email != null) 'email': email,
    if (country != null) 'country': country,
    if (password != null) 'password': password,
  };
}
