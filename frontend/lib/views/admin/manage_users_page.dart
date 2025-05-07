import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_response.dart';
import '../../services/providers.dart';

/// Provider som henter brugere én gang
final usersProvider = FutureProvider<List<UserResponse>>((ref) async {
  final api = ref.read(userApiServiceProvider);
  return api.getUsers(); // DU skal have en getUsers()-metode i din service
});

class ManageUsersPage extends ConsumerWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin – Brugere')),
      body: users.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fejl: $e')),
        data:
            (list) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final u = list[i];
                return ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(u.userName),
                  subtitle: Text(u.email),
                );
              },
            ),
      ),
    );
  }
}
