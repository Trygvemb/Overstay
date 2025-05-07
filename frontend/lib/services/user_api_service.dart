import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/create_user_request.dart';
import '../models/sign_in_user_request.dart';
import '../models/user_response.dart';
import '../models/sign_in_response.dart';
import '../services/api_exception.dart';

class UserApiService {
  final String baseUrl;
  UserApiService(this.baseUrl);

  // ---------- SIGN‑UP ----------
  Future<void> createUser(CreateUserRequest req) async {
    final uri = Uri.parse('$baseUrl/api/User');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'item': req.toJson()}),
    );
    print('SIGN‑IN status: ${res.statusCode}');
    print('SIGN‑IN body  : ${res.body}');

    if (res.statusCode == 201) return; // ✔️
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

    // --- DEBUG ---
    print('SIGN‑IN status : ${res.statusCode}');
    print('SIGN‑IN header : ${res.headers['authorization']}');
    print('SIGN‑IN body   : ${res.body}');

    // --- FEJLHÅNDTERING ---
    if (res.statusCode != 200) {
      if (res.statusCode == 401) throw ApiException(401, 'Unauthorized');
      throw ApiException(res.statusCode, res.body);
    }

    // --- 1. Parse body (først, så vi kan lede efter token dér) ---
    final bodyJson = jsonDecode(res.body) as Map<String, dynamic>;

    // --- 2. Hent JWT ---
    //    a) prøv i header
    String? token;
    final authHeader = res.headers['authorization']; // "Bearer eyJ..."
    if (authHeader != null && authHeader.startsWith('Bearer ')) {
      token = authHeader.substring(7);
    }

    //    b) ellers prøv i body -> accessToken
    token ??= bodyJson['accessToken'] as String?;

    if (token == null || token.isEmpty) {
      throw const FormatException('JWT token mangler i både header og body');
    }

    // --- 3. Uddrag evt. ekstra felter (kan være null) ---
    final userName = bodyJson['userName'] as String?; // kan mangle
    final email = bodyJson['email'] as String?; // kan mangle
    final id = bodyJson['id'] as String?; // kan mangle

    return SignInResponse(
      token: token,
      claims: const [], // opdater når API’et begynder at sende claims
      userName: userName,
      email: email,
      id: id,
    );
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
