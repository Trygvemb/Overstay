import 'package:flutter/material.dart';

class WhyPage extends StatelessWidget {
  const WhyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Why us page')),
      body: const Center(
        child: Text(
          'This is the about us page. Here you can find information on why you should use our app.',
          style: TextStyle(fontSize: 20, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
