import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:overstay_frontend/services/providers.dart';
import 'auth_state.dart';
import '../models/create_user_request.dart';
import '../models/sign_in_user_request.dart';
import '../models/user_response.dart';
import '../models/sign_in_response.dart';
import '../services/api_exception.dart';
import 'api_service.dart';

class UserApiService extends ApiService {
  final Ref ref;
  UserApiService(this.ref) : super(ref);

  // ---------- SIGN‑UP ----------
  Future<void> createUser(CreateUserRequest req) async {
    final res = await post('/api/User', {'item': req.toJson()});

    print('SIGN‑IN status: ${res.statusCode}');
    print('SIGN‑IN body  : ${res.body}');

    if (res.statusCode == 201) return;
    if (res.statusCode == 409) throw ApiException(409, 'User already exists');
    throw ApiException(res.statusCode, res.body);
  }

  // ---------- SIGN‑IN ----------
  Future<SignInResponse> signIn(SignInUserRequest req) async {
    final res = await post('/api/User/sign-in', {'item': req.toJson()});

    // --- DEBUG ---
    print('SIGN‑IN status : ${res.statusCode}');
    print('SIGN‑IN header : ${res.headers['authorization']}');
    print('SIGN‑IN body   : ${res.body}');
    print('SIGN-IN userId : ${ref.read<AuthState>(authStateProvider).userId}');

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
    final id = bodyJson['userId'] ?? bodyJson['id'] as String?; // kan mangle
    print(bodyJson.keys);

    return SignInResponse(
      token: token,
      claims: const [], // opdater når API’et begynder at sende claims
      userName: userName,
      email: email,
      id: id,
    );
  }

  // ───────── GET /api/User({id})) ─────────
  Future<UserResponse> getCurrentUser(String id) async {
    final res = await get('/api/User/$id');
    if (res.statusCode != 200) throw ApiException(res.statusCode, res.body);
    return UserResponse.fromJson(jsonDecode(res.body));
  }

  // ───────── PUT /api/User/{id} ─────────
  Future<void> updateUser(String id, Map<String, dynamic> payload) async {
    final res = await put('/api/User/$id', payload);
    if (res.statusCode != 204) throw (res);
  }

  // ---------- GET USERS ----------
  Future<List<UserResponse>> getUsers() async {
    final res = await get('/api/User');

    if (res.statusCode == 200) {
      final List json = jsonDecode(res.body);
      return json.map((e) => UserResponse.fromJson(e)).toList();
    }
    if (res.statusCode == 401) throw ApiException(401, 'Unauthorized');
    throw ApiException(res.statusCode, res.body);
  }
}
