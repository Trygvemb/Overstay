import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_api_service.dart';
import 'auth_state.dart';

///  API‑service til brugere
final userApiServiceProvider = Provider<UserApiService>((ref) {
  return UserApiService();
});

///  Global auth‑tilstand  (ChangeNotifier)
final authStateProvider = ChangeNotifierProvider<AuthState>(
  (ref) => AuthState(),
);
