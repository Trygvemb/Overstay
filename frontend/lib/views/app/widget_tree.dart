// lib/views/widget_tree.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/data/notifiers.dart';
import 'package:overstay_frontend/services/providers.dart';
import 'package:overstay_frontend/views/app/home_page.dart';
import 'package:overstay_frontend/views/app/visa_page.dart';
import 'package:overstay_frontend/views/app/profile_page.dart';
import 'package:overstay_frontend/views/app/notifications_page.dart';
import 'package:overstay_frontend/views/app/immigrationoffice_page.dart';
import 'package:overstay_frontend/views/public/landing_page.dart';
import 'package:overstay_frontend/views/admin/manage_users_page.dart';

class WidgetTree extends ConsumerWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(authStateProvider).isAdmin;

    //---------------------pages---------------------//
    // Her definerer vi de forskellige sider i appen
    final pages = <Widget>[
      const HomePage(), // index 0
      const VisaPage(), // index 1
      const ProfilePage(), // index 2
      const NotificationsPage(), // index 3
      const ImmigrationofficePage(), // index 4
    ];
    if (isAdmin) {
      pages.add(const ManageUsersPage()); // index 5
    }

    //---------------------navigations punkter---------------------//
    final navItems = <NavigationDestination>[
      const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      const NavigationDestination(icon: Icon(Icons.flight), label: 'Visa'),
      const NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      const NavigationDestination(
        icon: Icon(Icons.notifications),
        label: 'Notifications',
      ),
      const NavigationDestination(
        icon: Icon(Icons.location_pin),
        label: 'immigration offices',
      ),
    ];
    if (isAdmin) {
      navItems.add(
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings),
          label: 'admin',
        ),
      );
    }

    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (_, selectedPage, _) {
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
          body: pages[selectedPage], // Viser den valgte side
          // Bundnavigation
          bottomNavigationBar: NavigationBar(
            backgroundColor: const Color(0xFF1A759F),
            selectedIndex: selectedPage,
            onDestinationSelected: (index) {
              selectedPageNotifier.value = index;
            },
            destinations: navItems,
          ),
        );
      },
    );
  }
}
