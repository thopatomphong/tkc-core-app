import 'package:core_app/features/mail/mail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComposeScreen extends HookConsumerWidget {
  const ComposeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipientEmail = useTextEditingController();
    final subject = useTextEditingController();
    final body = useTextEditingController();
    final sending = useState(false);

    Future<void> send() async {
      sending.value = true;
      try {
        await ref
            .read(mailRepositoryProvider)
            .sendEmail(
              recipientEmails: [recipientEmail.text.trim()],
              subject: subject.text.trim(),
              body: body.text.trim(),
            );
        ref.invalidate(inboxProvider());
        if (context.mounted) context.pop();
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Send failed: $error')));
        }
      } finally {
        if (context.mounted) {
          sending.value = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Compose')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: recipientEmail,
            decoration: const InputDecoration(labelText: 'Recipient email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: subject,
            decoration: const InputDecoration(labelText: 'Subject'),
          ),
          TextField(
            controller: body,
            minLines: 8,
            maxLines: 12,
            decoration: const InputDecoration(labelText: 'Message'),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: sending.value ? null : send,
          icon: const Icon(Icons.send),
          label: const Text('Send'),
        ),
      ),
    );
  }
}
