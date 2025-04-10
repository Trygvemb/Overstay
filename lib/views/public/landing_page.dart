// lib/views/pages/landing_page.dart
import 'package:flutter/material.dart';
import 'package:overstay_frontend/views/auth/login_page.dart';
import 'package:overstay_frontend/views/public/about_page.dart';
import 'package:overstay_frontend/views/public/why_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Venstre: "Overstay"
            const Text(
              'Overstay',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            // Midten: 3 textbuttons
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'About',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WhyPage()),
                    );
                  },
                  child: const Text(
                    'Why',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            // Højre: Sign-up knap
            ElevatedButton(
              onPressed: () {
                // Naviger til widget_tree, som har bundnavigation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Sign-up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Are you also afraid of the risks of overstaying?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sign up and we will guide you through the visa rules in Thailand',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Samme navigering
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Sign-up', style: TextStyle(fontSize: 16)),
              ),
            ),
            const Spacer(),
            Center(child: Image.asset('assets/images/plane.png', height: 200)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.teal,
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          'Contact us',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
