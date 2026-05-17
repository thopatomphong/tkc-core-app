import 'package:core_app/features/mail/mail_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inbox = ref.watch(inboxProvider());
    return inbox.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: TextButton.icon(
          onPressed: () => ref.invalidate(inboxProvider()),
          icon: const Icon(Icons.refresh),
          label: Text('$error'),
        ),
      ),
      data: (page) {
        if (page.items.isEmpty) {
          return const Center(child: Text('No emails yet'));
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(inboxProvider()),
          child: ListView.builder(
            itemCount: page.items.length,
            itemBuilder: (context, index) {
              final email = page.items[index];
              return ListTile(
                leading: const Icon(Icons.mail_outline),
                title: Text(email.subject),
                subtitle: Text('${email.senderUsername}\n${email.body}'),
                isThreeLine: true,
                onTap: () => context.go('/mail/${email.id}'),
              );
            },
          ),
        );
      },
    );
  }
}
