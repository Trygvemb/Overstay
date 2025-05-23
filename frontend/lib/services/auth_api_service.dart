import 'package:web/web.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/services/api_service.dart';
import 'package:overstay_frontend/services/providers.dart';

class AuthApiService extends ApiService {
  final Ref ref;
  AuthApiService(this.ref) : super(ref);

  Future<void> externalLogIn(String provider, String returnUrl) async {
    final baseUrl = ref.read(apiBaseUrlProvider);
    //final url = '$baseUrl/api/Auth/external-login?provider=$provider&returnUrl=$returnUrl';
    final url = '$baseUrl/api/Auth/external-login?provider=$provider&returnUrl=$returnUrl';
    window.location.href = url; // <-- Redirect browser using web.dart
  }
}