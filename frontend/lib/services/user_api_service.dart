import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/create_user_request.dart';
import '../models/sign_in_user_request.dart';
import '../models/user_response.dart';
import '../models/sign_in_response.dart';
import '../services/api_exception.dart';
import 'api_service.dart';

class UserApiService {
  final String _baseUrl =
      dotenv.env['API_BASE_URL']!; // fx http://localhost:5050

  // ---------- SIGN-UP ----------
  Future<void> createUser(CreateUserRequest req) async {
    final uri = Uri.parse('$_baseUrl/api/User');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'item': req.toJson()}),
    );

    if (res.statusCode == 201) return;
    if (res.statusCode == 409) throw ApiException(409, 'User already exists');
    throw ApiException(res.statusCode, res.body);
  }

  // ---------- SIGN-IN ----------
  Future<SignInResponse> signIn(SignInUserRequest req) async {
    // <-- ændret returtype
    final uri = Uri.parse('$_baseUrl/api/User/sign-in');

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'item': req.toJson()}),
    );

    if (res.statusCode == 200) {
      return SignInResponse.fromJson(
        jsonDecode(res.body),
      ); // <-- returnér objekt m. token
    }
    if (res.statusCode == 401) {
      throw ApiException(401, 'Unauthorized');
    }
    throw ApiException(res.statusCode, res.body);
  }

  // ---------- GET USERS ----------
  Future<List<UserResponse>> getUsers() async {
    final uri = Uri.parse('$_baseUrl/api/User');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      final List json = jsonDecode(res.body);
      return json.map((e) => UserResponse.fromJson(e)).toList();
    }
    if (res.statusCode == 401) {
      throw ApiException(401, 'Unauthorized');
    }
    throw ApiException(res.statusCode, res.body);
  }
}
