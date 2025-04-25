import 'package:flutter/material.dart';
import 'package:overstay_frontend/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          selectedIndex: selectedPage,
          onDestinationSelected: (int newIndex) {
            // Opdater ValueNotifier, så vi skifter side i widget_tree
            selectedPageNotifier.value = newIndex;
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.flight), label: 'Visa'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      },
    );
  }
}
