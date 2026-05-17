import 'package:core_app/features/auth/auth_controller.dart';
import 'package:core_app/features/mail/inbox_screen.dart';
import 'package:core_app/features/launcher/post_login_effects.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LauncherScreen extends ConsumerWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(postLoginEffectsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TKC Mail'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: const InboxScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/compose'),
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/shopping'),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Shopping'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/concert'),
                  icon: const Icon(Icons.confirmation_num_outlined),
                  label: const Text('Concerts'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
