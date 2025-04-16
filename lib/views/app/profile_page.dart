import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

//controller til at håndtere tilstand og interaktioner i profilformularen
class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // venstre side gradient
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
              child: _buildProfileForm(context),
            ),
          ),
          // højre side
          Expanded(
            flex: 1,
            child: Center(child: Image.asset('assets/images/passport.png')),
          ),
        ],
      ),
    );
  }

  // Widget til at bygge profilformularen
  // Denne widget indeholder tekstfelter til navn og email samt en gem-knap
  Widget _buildProfileForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),

          //First name
          Text(
            'First Name',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          _buildTextField(firstNameController, 'First name'),
          const SizedBox(height: 16),

          //Last name
          const Text(
            'Last name',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          _buildTextField(lastNameController, 'Last name'),
          const SizedBox(height: 16),

          // Email
          const Text(
            'Email',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          _buildTextField(emailController, 'Email'),
          const SizedBox(height: 16),

          // Password
          const Text(
            'Password',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          _buildTextField(passwordController, 'Password', isPassword: true),
          const SizedBox(height: 24),

          //vandret streg
          Divider(thickness: 2, color: const Color(0xFF1A759F)),
          const SizedBox(height: 16),

          // Row save og slet button
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  //handle save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A759F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),

              ElevatedButton(
                onPressed: () {
                  //handle delete action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A759F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
