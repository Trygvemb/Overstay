import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_theme.dart';
import 'services/providers.dart'; // <-- for apiBaseUrlProvider
import 'views/public/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const LandingPage(), // behøver ingen apiBaseUrl‑param
    );
  }
}
