//tanken er at denne skal håndtere én bruger
// id, firstName, lastName, email
// denne model skal dog være tilsvarende den der er i MockUSer??.cs!! vigtigt!!

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  // — JSON → User
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
  );

  // — User → JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
  };
}
