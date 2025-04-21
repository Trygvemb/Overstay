import 'package:flutter/material.dart';
import 'package:overstay_frontend/views/auth/signup_page.dart';
import 'package:overstay_frontend/views/app/widget_tree.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

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
              const Text('Email', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              _buildTextField(
                controller: emailController,
                hintText: 'Enter your email',
                isPassword: false,
              ),

              const SizedBox(height: 20),

              //password input
              const Text('Password', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              _buildTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                isPassword: true,
              ),
              const SizedBox(height: 30),

              //login button
              Center(
                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () => login(context),
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
                    'Don\'t have an account? Sign up',
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
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulate a network request
    // bool success = await AuthService.login(email, password);
    await Future.delayed(const Duration(seconds: 2));
    bool success = (email == 'test@mail.com' && password == '1234');
    // Simulate success

    setState(() {
      isLoading = false;
    });

    if (success) {
      // ved success naviger til private app-sider
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login failed')));
    }
  }
}
