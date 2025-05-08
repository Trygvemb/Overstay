import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';
import 'user_api_service.dart';
import 'visa_api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Holder base‑URL (sættes som override i main.dart)
final apiBaseUrlProvider = Provider<String>((_) {
  throw UnimplementedError('apiBaseUrlProvider skal overrides i main()');
});

/// API‑service – får base‑url fra provider‑træet
final userApiServiceProvider = Provider<UserApiService>((ref) {
  return UserApiService(ref);
});

/// Global auth‑state (ChangeNotifier)
final authStateProvider = ChangeNotifierProvider<AuthState>(
  (ref) => AuthState(),
);

/// API‑service til visa
final visaApiServiceProvider = Provider<VisaApiService>((ref) {
  return VisaApiService(ref);
});
