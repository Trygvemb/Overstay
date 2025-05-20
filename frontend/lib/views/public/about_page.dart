import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Overstay'),
        backgroundColor: const Color(0xFF1A759F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/plane.png', height: 100),
              const SizedBox(height: 30),
              const Text(
                'Who are we?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A759F),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Overstay is your digital companion for stress-free travel in Thailand. We are passionate developers and travelers who know the pain of navigating complex visa rules. That’s why we’ve built a modern, user-friendly app dedicated to keeping you informed, organized, and safe from unexpected overstays.',
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              const Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF34A0A4),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'To make it simple for travelers to track visa dates, get reminders before expiry, and stay compliant with Thai immigration rules – all in one beautiful app.',
                style: TextStyle(fontSize: 17, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              const Text(
                'Meet the Team',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF168AAD),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We are a little passionate international group of IT professionals and designers committed to delivering real value to fellow explorers.',
                style: TextStyle(fontSize: 17, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
