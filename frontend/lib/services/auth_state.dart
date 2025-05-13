import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  String? _token; // JWT token
  bool _admin = false;
  String? _userId;
  String? _userName;
  String? _email;

  //-----------------Getters-------------------
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
    _token = token;
    _admin = admin;
    _userId = userId;
    _userName = userName;
    _email = email;
    notifyListeners();
  }

  void clear() {
    _token = null;
    _admin = false;
    _userName = null;
    _userId = null;
    _email = null;
    notifyListeners();
  }
}
