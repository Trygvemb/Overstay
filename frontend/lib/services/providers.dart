import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/models/visa_respons.dart';
import 'auth_state.dart';
import 'user_api_service.dart';
import 'visa_api_service.dart';
import 'package:overstay_frontend/models/user_response.dart';
import 'package:overstay_frontend/models/update_user_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:overstay_frontend/models/notification_settings.dart';
import 'package:overstay_frontend/services/notifications_api_service.dart';
import 'package:overstay_frontend/services/api_exception.dart';

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

/// Senest gemte visa som FutureProvider
final currentVisaProvider = FutureProvider<VisaResponse?>((ref) async {
  final api = ref.read(visaApiServiceProvider);
  return api.getCurrentVisa();
});

/// Aktuel brugerprofil
final currentUserProvider = FutureProvider<UserResponse>((ref) async {
  final api = ref.read(userApiServiceProvider);
  final userId = ref.read(authStateProvider).userId!;
  return api.getCurrentUser(userId);
});

// --------------------- Notification API ---------------------

// service-provider
final notificationApiProvider = Provider<NotificationApiService>(
  (ref) => NotificationApiService(ref),
);

// auto-load brugerens aktuelle settings (kan være null første gang)
final currentNotificationProvider = FutureProvider<NotificationSettings?>((
  ref,
) async {
  final api = ref.read(notificationApiProvider);
  // getSettings() kaster selv ApiException hvis noget går galt,
  //  men returnerer null, hvis back-end svarer 404 (ingen record endnu)
  return api.getSettings();
});
