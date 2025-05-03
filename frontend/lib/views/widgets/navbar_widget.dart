import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/data/notifiers.dart';
import 'package:overstay_frontend/services/providers.dart';

class NavbarWidget extends ConsumerWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(authStateProvider).isAdmin;

    final destinations = <NavigationDestination>[
      const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      const NavigationDestination(icon: Icon(Icons.flight), label: 'Visa'),
      const NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
    ];

    // HVis brugeren er admin
    if (isAdmin) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      );
    }

    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (_, selected, _) {
        return NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (index) => selectedPageNotifier.value = index,
          destinations: destinations,
        );
      },
    );
  }
}
