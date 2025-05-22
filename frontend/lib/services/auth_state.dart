import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false; // true hvis brugeren er logget ind
  String? _token; // JWT token
  bool _admin = false;
  String? _userId;
  String? _userName;
  String? _email;

  //-----------------Getters-------------------
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  bool get isAdmin => _admin;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get email => _email;

  //-----------------Setters-------------------
  //kaldes efter login
  void setAuth({
    required String token,
    required bool admin,
    required String? userId,
    required String? userName,
    required String? email,
  }) {
    _isAuthenticated = true;
    _token = token;
    _admin = admin;
    _userId = userId;
    _userName = userName;
    _email = email;
    notifyListeners();
  }

  void clear() {
    _isAuthenticated = false;
    _token = null;
    _admin = false;
    _userName = null;
    _userId = null;
    _email = null;
    notifyListeners();
  }
}
