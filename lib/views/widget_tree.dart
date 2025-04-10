// lib/views/widget_tree.dart
import 'package:flutter/material.dart';
import 'package:overstay_frontend/data/notifiers.dart';
import 'package:overstay_frontend/views/pages/home_page.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(), // index 0
      const Placeholder(
        // index 1 (fx VisaPage)
        color: Colors.orange,
        child: Center(child: Text('Visa Page')),
      ),
      const Placeholder(
        // index 2 (fx ProfilePage)
        color: Colors.green,
        child: Center(child: Text('Profile Page')),
      ),
    ];

    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Overstay - Inner Pages'),
            backgroundColor: Colors.teal,
          ),
          body: pages[selectedPage],
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedPage,
            onDestinationSelected: (newIndex) {
              selectedPageNotifier.value = newIndex;
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.flight), label: 'Visa'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
