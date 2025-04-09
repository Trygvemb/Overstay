import 'package:flutter/material.dart';
import 'package:overstay/views/pages/home_page.dart';
import 'package:overstay/views/pages/landing_page.dart';
import 'package:overstay/views/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overstay',
      theme: ThemeData()
    )
  }
}