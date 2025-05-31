//Dummy login page for testing purposes

import 'package:flutter/material.dart';

class SimpleLoginPage extends StatefulWidget {
  const SimpleLoginPage({super.key});

  @override
  State<SimpleLoginPage> createState() => _SimpleLoginPageState();
}

class _SimpleLoginPageState extends State<SimpleLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  key: const Key('username'),
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Username required'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('password'),
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Password required'
                              : null,
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _errorMessage!,
                      key: const Key('error_message'),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key('login_button'),
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                    });
                    if (_formKey.currentState!.validate()) {
                      // Simpel dummy login
                      if (_usernameController.text == "test" &&
                          _passwordController.text == "1234") {
                        // login success
                      } else {
                        setState(() {
                          _errorMessage = "Wrong username or password";
                        });
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  key: const Key('signup_btn'),
                  onPressed: () {
                    // tom til test, men viser her at det er her navigation til signup skal være
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: const Text("Don't have an account? Create one here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// This is a dummy login page for testing purposes.
// It contains a single button that does nothing when pressed.
