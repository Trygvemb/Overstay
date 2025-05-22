import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:overstay_frontend/services/user_api_service.dart';
import 'package:overstay_frontend/models/create_user_request.dart';
import 'package:overstay_frontend/models/create_user_response.dart';
import 'package:overstay_frontend/models/sign_in_user_request.dart';
import 'package:overstay_frontend/services/api_exception.dart';
import 'package:overstay_frontend/services/providers.dart';
import 'package:overstay_frontend/views/app/home_page.dart';
import 'package:overstay_frontend/views/auth/login_page.dart';
import 'package:overstay_frontend/views/app/widget_tree.dart';
import 'dart:developer';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  // Controller til at håndtere tekstfelter
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedCountryId; // valgt land
  final storage =
      const FlutterSecureStorage(); // krypteret i både IOS og Android

  //api (hentes via provider)
  late final UserApiService _api;

  // eye-toggle til password
  bool _obscurePassoword = true;

  @override
  void initState() {
    super.initState();
    // henter instansen én gang via Riverpod
    _api = ref.read(userApiServiceProvider);
  }

  // mock data til lande
  final List<Map<String, String>> countries = [
    // ←  GUID + navn
    {'id': 'd6cf4d61-5f80-48aa-9cb6-ec7604024106', 'name': 'Denmark'},
    {'id': 'b242b2a4-2d23-49bf-8198-802865cf6be0', 'name': 'Sweden'},
    {'id': 'a1b2c3d4-e5f6-7g8h-9i0j-k1l2m3n4o5p6', 'name': 'Norway'},
    {'id': '7f8e9d0c-b1a2-3b4c-5d6e-7f8g9h0i1j2k', 'name': 'Finland'},
    // ...
  ];

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
      body: Row(
        children: [
          // Venstre sektion
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overstay helps you keep\ntrack of your Visa',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        'assets/images/visamap.png',
                        height: 200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Højre sektion
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB2DFDB), Color(0xFF80CBC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Username input field
                    TextField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email input field
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Country dropdown
                    DropdownButtonFormField<String>(
                      value: selectedCountryId,
                      items:
                          countries.map((c) {
                            return DropdownMenuItem(
                              value: c['id'],
                              child: Text(c['name']!),
                            );
                          }).toList(),
                      onChanged:
                          (String? id) =>
                              setState(() => selectedCountryId = id),
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Password input field
                    TextField(
                      controller: passwordController,
                      obscureText:
                          _obscurePassoword, // toggle password visibility
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        // suffixIcon til at vise/skjule password
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassoword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassoword = !_obscurePassoword;
                            });
                          },
                        ),
                      ),
                      onSubmitted:
                          (_) =>
                              _createAccount(), //så oprettes konto ved ENTERR
                    ),
                    const SizedBox(height: 20),

                    // Create account button //
                    Center(
                      child: ElevatedButton(
                        onPressed: _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'Create account',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login navigation button //
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // kald til API
  Future<void> _createAccount() async {
    final userName = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    //1 validate input (er felterne tomme? er email gyldig? osv.)
    if ([
      userName,
      email,
      password,
      selectedCountryId,
    ].any((e) => e == null || (e as String).isEmpty)) {
      // Hvis et af felterne er tomt
      // Vis en fejlmeddelelse
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      //1 – opret en CreateUserRequest/bruger
      final request = CreateUserRequest(
        userName: userName,
        email: email,
        password: password,
        countryId: selectedCountryId,
      );

      // 2  – kald API’et - vi forventer 201 (kaster ApiException hvis der er fejl)
      print('createUser() start');
      await _api.createUser(request);
      log('User created: $userName}');
      print('createUser ok');

      // 3  – log straks ind med de samme credentials
      print('signIn() start');
      final signInRes = await _api.signIn(
        SignInUserRequest(userName: userName, password: password),
      );
      print('signIn ok - Token: ${signInRes.token}');

      // 4  – gem auth‑state
      ref
          .read(authStateProvider)
          .setAuth(
            token: signInRes.token,
            admin: signInRes.claims.contains('Admin'),
            userId: signInRes.id,
            userName:
                (signInRes.userName != null && signInRes.userName!.isNotEmpty)
                    ? signInRes.userName!
                    : userName, // bruger det tastede brugernavn
            email:
                (signInRes.email != null && signInRes.email!.isNotEmpty)
                    ? signInRes.email!
                    : email, // bruger den tastede mail
          );

      // 5 – vis succes‑melding og gå til appen
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created – welcome!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
        (_) => false,
      );

      // ---- fejlhåndtering ----
    } on ApiException catch (e) {
      final msg =
          e.statusCode == 409
              ? 'User already exists'
              : 'Signup failed: (${e.statusCode}): ${e.message}';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      // Håndter eventuelle andre fejl
      debugPrint('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, try again')),
      );
    }
  }
}
