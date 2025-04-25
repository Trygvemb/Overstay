// lib/views/widget_tree.dart
import 'package:flutter/material.dart';
import 'package:overstay_frontend/data/notifiers.dart';
import 'package:overstay_frontend/views/app/home_page.dart';
import 'package:overstay_frontend/views/app/visa_page.dart';
import 'package:overstay_frontend/views/app/profile_page.dart';
import 'package:overstay_frontend/views/app/notifications_page.dart';
import 'package:overstay_frontend/views/app/immigrationoffice_page.dart';
import 'package:overstay_frontend/views/public/landing_page.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(), // index 0
      const VisaPage(), // index 1
      const ProfilePage(), // index 2
      const NotificationsPage(), // index 3
      const ImmigrationofficePage(), // index 4
    ];

    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          appBar: AppBar(
            // Top AppBar
            backgroundColor: const Color(0xFF1A759F),
            title: const Text('Overstay - Inner Pages'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LandingPage()),
                    (route) => false, // sikre at man har tømt stacken
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: pages[selectedPage],
          bottomNavigationBar: NavigationBar(
            backgroundColor: const Color(0xFF1A759F),
            selectedIndex: selectedPage,
            onDestinationSelected: (newIndex) {
              selectedPageNotifier.value = newIndex;
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.flight), label: 'Visa'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
              NavigationDestination(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              NavigationDestination(
                icon: Icon(Icons.location_pin),
                label: 'Immigration offices',
              ),
            ],
          ),
        );
      },
    );
  }
}
