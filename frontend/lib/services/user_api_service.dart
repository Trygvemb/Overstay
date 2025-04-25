import '../models/create_user_request.dart';
import '../models/sign_in_user_request.dart';
import '../models/user_response.dart';
import 'api_service.dart';

class UserApiService extends ApiService {
  /// POST /api/User  – registrér ny bruger
  Future<UserResponse> createUser(CreateUserRequest req) async {
    final res = await post('/api/User', {'item': req.toJson()});
    return parse(res, (j) => UserResponse.fromJson(j));
  }

  /// POST /api/User/sign-in  – login
  Future<UserResponse> signIn(SignInUserRequest req) async {
    final res = await post('/api/User/sign-in', {'item': req.toJson()});
    final user = parse(res, (j) => UserResponse.fromJson(j));
    // gem evt. JWT token fra header til dotenv eller secure storage
    return user;
  }

  /// GET /api/User/{id}
  Future<UserResponse> getUser(String id) async {
    final res = await get('/api/User/$id');
    return parse(res, (j) => UserResponse.fromJson(j));
  }

  /// DELETE /api/User/{id}
  Future<void> deleteUser(String id) async {
    final res = await delete('/api/User/$id');
    if (res.statusCode != 204) _throw(res);
  }

  void _throw(res) =>
      throw Exception('API-fejl ${res.statusCode}: ${res.body}');
}
