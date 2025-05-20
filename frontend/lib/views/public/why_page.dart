import 'package:flutter/material.dart';

class WhyPage extends StatelessWidget {
  const WhyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Why Choose Overstay?'),
        backgroundColor: const Color(0xFF1A759F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/passport.png', height: 100),
              const SizedBox(height: 28),
              const Text(
                'Why Overstay?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A759F),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Staying compliant with visa requirements can be confusing and stressful. Overstay is here to make your travels safer, easier, and worry-free.',
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const ListTile(
                leading: Icon(Icons.alarm, color: Color(0xFF168AAD)),
                title: Text(
                  'Automatic Reminders',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Never miss a deadline – get notified before your visa expires.',
                ),
              ),
              const ListTile(
                leading: Icon(Icons.flight_takeoff, color: Color(0xFF168AAD)),
                title: Text(
                  'Easy Overview',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'All your visa details in one place. No more guesswork.',
                ),
              ),
              const ListTile(
                leading: Icon(Icons.lock, color: Color(0xFF168AAD)),
                title: Text(
                  'Privacy & Security',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Your data is safe – we use modern security best practices.',
                ),
              ),
              const ListTile(
                leading: Icon(Icons.group, color: Color(0xFF168AAD)),
                title: Text(
                  'For Travelers, By Travelers',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Created by people who understand your needs and challenges.',
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Choose Overstay, and travel with confidence!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF34A0A4),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
