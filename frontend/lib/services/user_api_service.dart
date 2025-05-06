import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/create_user_request.dart';
import '../models/create_user_response.dart';
import '../models/sign_in_user_request.dart';
import '../models/user_response.dart';
import '../models/sign_in_response.dart';
import '../services/api_exception.dart';

class UserApiService {
  final String baseUrl;
  UserApiService(this.baseUrl);

  // ---------- SIGN‑UP ----------
  Future<CreateUserResponse> createUser(CreateUserRequest req) async {
    final uri = Uri.parse('$baseUrl/api/User');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'item': req.toJson()}),
    );

    if (res.statusCode == 201) {
      return CreateUserResponse.fromJson(jsonDecode(res.body));
    }
    if (res.statusCode == 409) throw ApiException(409, 'User already exists');
    throw ApiException(res.statusCode, res.body);
  }

  // ---------- SIGN‑IN ----------
  Future<SignInResponse> signIn(SignInUserRequest req) async {
    final uri = Uri.parse('$baseUrl/api/User/sign-in');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'item': req.toJson()}),
    );

    if (res.statusCode == 200) {
      return SignInResponse.fromJson(jsonDecode(res.body));
    }
    if (res.statusCode == 401) throw ApiException(401, 'Unauthorized');
    throw ApiException(res.statusCode, res.body);
  }

  // ---------- GET USERS ----------
  Future<List<UserResponse>> getUsers() async {
    final uri = Uri.parse('$baseUrl/api/User');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      final List json = jsonDecode(res.body);
      return json.map((e) => UserResponse.fromJson(e)).toList();
    }
    if (res.statusCode == 401) throw ApiException(401, 'Unauthorized');
    throw ApiException(res.statusCode, res.body);
  }
}
