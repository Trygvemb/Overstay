import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  String? jwt;
  bool isAdmin = false;

  String? userName;
  String? email;

  //kaldes efter login
  void setAuth({
    required String token,
    required bool admin,
    required String userName,
    required String email,
  }) {
    jwt = token;
    isAdmin = admin;
    this.userName = userName;
    this.email = email;
    notifyListeners();
  }

  void clear() {
    jwt = null;
    isAdmin = false;
    userName = null;
    email = null;
    notifyListeners();
  }
}
