import 'package:flutter/material.dart';
import 'package:overstay_frontend/views/auth/login_page.dart';
import 'package:overstay_frontend/views/public/about_page.dart';
import 'package:overstay_frontend/views/public/why_page.dart';
import 'package:overstay_frontend/views/app/widget_tree.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1) Top AppBar
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A759F),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Venstre: "Overstay" Brandname
            const Text(
              'Overstay',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            // Midten: 3 textbuttons, Home, About, Why
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LandingPage()),
                    );
                  },
                  child: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutPage()),
                    );
                  },
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
            // Højre: Login knap
            ElevatedButton(
              onPressed: () {
                // Naviger til login siden
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
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),

      // 2) Body -> Row: Venstre = tekst + knap, Højre = billede
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Venstre: Tekst + knap
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are you also afraid of the risks of overstaying?',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sign up and we will guide you through the visa rules in Thailand',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
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
                    child: const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            // Højre side
            Expanded(
              flex: 1,
              child: Center(
                child: Image.asset('assets/images/plane.png', height: 250),
              ),
            ),
          ],
        ),
      ),

      // 3) Bund -> 'Contact us' til venstre og ' VISA-TRACKER' til højre)
      bottomNavigationBar: Container(
        color: const Color(0xFF1A759F),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Klikbar Contact us
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Contact us'),
                        content: const Text(
                          'Do you have questions or feedback?\n\nContact us at:\n\nsupport@mail.com',
                          style: TextStyle(fontSize: 18),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                );
              },
              child: const Text(
                'Contact us',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            // Højre: 'VISA-TRACKER'
            const Text('VISA-TRACKER', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
