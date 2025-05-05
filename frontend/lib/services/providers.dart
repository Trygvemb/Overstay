import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';
import 'user_api_service.dart';

/// Holder base‑URL (sættes som override i main.dart)
final apiBaseUrlProvider = Provider<String>((_) {
  throw UnimplementedError('apiBaseUrlProvider skal overrides i main()');
});

/// API‑service – får base‑url fra provider‑træet
final userApiServiceProvider = Provider<UserApiService>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  return UserApiService(baseUrl); // <- Tilpas konstruktøren hvis nødvendigt
});

/// Global auth‑state (ChangeNotifier)
final authStateProvider = ChangeNotifierProvider<AuthState>(
  (ref) => AuthState(),
);
