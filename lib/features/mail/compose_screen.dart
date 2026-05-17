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
      body: SafeArea(
        child: Column(
          children: [
            _ComposeHeader(
              onCancel: () => context.pop(),
              onSend: send,
              isSendEnabled: !sending.value,
            ),
            Expanded(
              child: ListView(
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
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposeHeader extends StatelessWidget {
  const _ComposeHeader({
    required this.onCancel,
    required this.onSend,
    required this.isSendEnabled,
  });

  final VoidCallback onCancel;
  final VoidCallback onSend;
  final bool isSendEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onCancel,
            child: const Text(
              '< Cancel',
              style: TextStyle(color: Color(0xFFFF3B30), fontSize: 17),
            ),
          ),
          const Text(
            'New Email',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          ElevatedButton.icon(
            onPressed: isSendEnabled ? onSend : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
