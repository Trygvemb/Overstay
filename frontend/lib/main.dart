import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/views/app/widget_tree.dart';
import 'package:overstay_frontend/views/auth/loading_page.dart';
import 'package:overstay_frontend/views/auth/login_page.dart';
import 'package:overstay_frontend/views/auth/signup_page.dart';
import 'package:overstay_frontend/views/public/about_page.dart';
import 'package:overstay_frontend/views/public/why_page.dart';
import 'config/app_theme.dart';
import 'services/providers.dart'; // <-- for apiBaseUrlProvider
import 'views/public/landing_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUrlStrategy(PathUrlStrategy());

  // Læs base‑url fra --dart-define (flutter run --dart-define=API_BASE_URL=...)
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5050', // fallback til lokal udvikling
  );

  runApp(
    ProviderScope(
      overrides: [
        apiBaseUrlProvider.overrideWithValue(apiBaseUrl), // <- det vigtige!
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overstay',
      theme: AppTheme.lightTheme,
      initialRoute: '/', // <-- Add this line
      routes: {
        '/': (context) => const LandingPage(),
        '/loading': (context) => const LoadingPage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const WidgetTree(),
        '/visa': (context) => const WidgetTree(),
        '/profile': (context) => const WidgetTree(),
        '/notifications': (context) => const WidgetTree(),
        '/immigration': (context) => const WidgetTree(),
        '/admin': (context) => const WidgetTree(),
        '/about': (context) => const AboutPage(),
        '/why': (context) => const WhyPage(),
      },
    );
  }
}
