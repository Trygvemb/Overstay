import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  String? jwt;
  bool isAdmin = false;

  void setAuth(String token, bool admin) {
    jwt = token;
    isAdmin = admin;
    notifyListeners();
  }

  void clear() {
    jwt = null;
    isAdmin = false;
    notifyListeners();
  }
}
