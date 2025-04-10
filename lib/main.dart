// Dette er den primære indgangspunkt for Flutter-app.
import 'package:flutter/material.dart';
import 'package:overstay_frontend/config/app_theme.dart';
import 'package:overstay_frontend/views/public/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overstay',
      theme: AppTheme.lightTheme,
      home: const LandingPage(), // Start med LandingPage
    );
  }
}
