// Dette er den primære indgangspunkt for Flutter-app.
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/config/app_theme.dart';
import 'package:overstay_frontend/views/public/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Sikrer at Flutter er klar til at køre
  await dotenv
      .load(); // Indlæser miljøvariabler fra .env filen som finde i roden
  runApp(const ProviderScope(child: MyApp()));
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
