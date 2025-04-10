// Dette er den primære indgangspunkt for Flutter-app.
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
      theme: ThemeData(
        // Her kan du fx definere colorScheme, fonts m.m.
        primarySwatch: Colors.teal,
      ),
      home: const LandingPage(), // Start med LandingPage
    );
  }
}
