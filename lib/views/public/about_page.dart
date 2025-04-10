import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About us page')),
      body: const Center(
        child: Text(
          'This is the about us page. Here you can find information about our app and team.',
          style: TextStyle(fontSize: 20, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
