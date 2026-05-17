import 'package:core_app/features/mail/mail_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailDetailScreen extends ConsumerWidget {
  const EmailDetailScreen({required this.emailId, super.key});

  final int emailId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailDetailProvider(emailId));
    return Scaffold(
      appBar: AppBar(title: const Text('Email')),
      body: email.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (message) => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Text(
              message.subject,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('From: ${message.senderUsername}'),
            Text('To: ${message.recipientUsername}'),
            const Divider(height: 32),
            Text(message.body),
          ],
        ),
      ),
    );
  }
}
