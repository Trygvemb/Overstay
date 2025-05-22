import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:overstay_frontend/services/providers.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkJwtCookieAndLogin();
  }

  Future<void> _checkJwtCookieAndLogin() async {
    final cookies = html.document.cookie ?? '';
    final jwtCookie = cookies
        .split(';')
        .map((c) => c.trim())
        .firstWhere((c) => c.startsWith('AuthToken='), orElse: () => '');

    if (jwtCookie.isNotEmpty) {
      final token = jwtCookie.substring('AuthToken='.length);
      await _storage.write(key: 'jwt', value: token);

      // Decode JWT
      final decodedToken = JwtDecoder.decode(token);

      // Extract claims (see TokenService.cs for claim types)
      final userId =
          decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
          '';
      final userName =
          decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ??
          '';
      final email =
          decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
          '';
      final roles =
          decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      final isAdmin =
          roles is List ? roles.contains('Admin') : roles == 'Admin';

      // Set auth state
      ref
          .read(authStateProvider)
          .setAuth(
            token: token,
            admin: isAdmin,
            userId: userId,
            userName: userName,
            email: email,
          );

      // Navigate to correct page
      if (!mounted) return;
      if (ref.read(authStateProvider).isAuthenticated) {
        // User is authenticated, go to home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // User is not authenticated, go to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
