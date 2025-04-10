import 'package:flutter/material.dart';
import 'package:overstay_frontend/views/pages/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overstay',
      theme: ThemeData(),
      home: const LandingPage(), // Set LandingPage as the initial page
    );
  }
}
