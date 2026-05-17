import 'package:core_app/features/profile/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (value) => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(value.displayName ?? value.username),
              subtitle: Text('@${value.username}'),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(value.email),
            ),
          ],
        ),
      ),
    );
  }
}
