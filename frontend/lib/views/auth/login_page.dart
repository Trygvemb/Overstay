import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/models/sign_in_user_request.dart';
import 'package:overstay_frontend/services/user_api_service.dart';
import 'package:overstay_frontend/views/auth/signup_page.dart';
import 'package:overstay_frontend/views/app/widget_tree.dart';
import 'package:overstay_frontend/services/api_exception.dart';
import 'package:overstay_frontend/services/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // ------- controller til at håndtere tekstfelter ----- //
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final UserApiService _api;
  final _storage =
      const FlutterSecureStorage(); // krypteret i både IOS og Android

  bool _loading = false;
  bool _obscurePassoword = true; // til at skjule password i tekstfeltet

  @override
  void initState() {
    super.initState();
    // henter instansen én gang via Riverpod
    _api = ref.read(userApiServiceProvider);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar med leading-tilbage knap til SignupPage
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignupPage()),
            );
          },
        ),
      ),
      body: Row(
        children: [
          // 1) Venstre side
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Welcome back\n\n Overstay helps you track your Visa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // 2) Højre side
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF99D98C),
                    Color(0xFF76C893),
                    Color(0xFF52B69A),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: _buildLoginForm(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              //email input
              const Text('Username', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: 'Enter your username',
                isPassword: false,
              ),

              const SizedBox(height: 20),

              //password input
              const Text('Password', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Enter your password',
                isPassword: true,
              ),
              const SizedBox(height: 30),

              //login button
              Center(
                child:
                    _loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A759F),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
              ),
              const SizedBox(height: 20),

              // Google login button
              Center(
                child: InkWell(
                  onTap: () {
                    html.window.location.href =
                        'http://localhost:5050/api/Auth/external-login?provider=Google';
                  },
                  child: SvgPicture.asset(
                    'assets/images/signin_w_google.svg',
                    height: 48, // ved ikke om den skal være lidt mindre?
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              //Link to SignupPage
              Center(
                child: TextButton(
                  onPressed: () {
                    // Naviger til signup siden
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Create one here',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassoword : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        // suffixIcon til at vise/skjule password
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    _obscurePassoword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassoword = !_obscurePassoword;
                    });
                  },
                )
                : null,
      ),
      onSubmitted: (_) => _login(context),
    );
  }

  // --------------Login logic----------------
  Future<void> _login(BuildContext context) async {
    final typedIdentifier = _emailController.text.trim();
    final password = _passwordController.text;

    if (typedIdentifier.isEmpty || password.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // Call the API to sign in
      final response = await _api.signIn(
        SignInUserRequest(userName: typedIdentifier, password: password),
      );

      // gem token i secure storage
      await _storage.write(key: 'jwt', value: response.token);

      ref
          .read(authStateProvider)
          .setAuth(
            token: response.token,
            admin: response.claims.contains('Admin'),
            userId: response.id,
            userName:
                (response.userName != null && response.userName!.isNotEmpty)
                    ? response.userName!
                    : typedIdentifier, // bruger inputtet som fallback
            email:
                (response.email != null && response.email!.isNotEmpty)
                    ? response.email!
                    : (typedIdentifier.contains(
                          '@',
                        ) // kun hvis det ligner en mail
                        ? typedIdentifier
                        : ''),
          );

      // Naviger til WidgetTree
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );
      return; // <- stop her hvis success
    } on ApiException catch (e) {
      // ***** Fejl fra back-end *****
      if (e.statusCode != 401)
        _show('Login failed (${e.statusCode}): ${e.message}');
      // falder ned til dummy-login
    } finally {
      if (mounted) setState(() => _loading = false);
    }

    // ===== Dummy-login =====
    if (typedIdentifier == 'test@mail.com' && password == '1234') {
      await _storage.write(key: 'jwt', value: 'dummy-token');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WidgetTree()),
        );
      }
    } else {
      _show('Wrong e-mail or password');
    }
  }

  void _show(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
