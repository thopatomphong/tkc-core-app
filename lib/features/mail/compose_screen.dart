import 'package:core_app/features/mail/mail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComposeScreen extends HookConsumerWidget {
  const ComposeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipients = useState(<String>[]);
    final subject = useTextEditingController();
    final body = useTextEditingController();
    final sending = useState(false);
    final isFormattingActive = useState(false);

    Future<void> send() async {
      sending.value = true;
      try {
        await ref
            .read(mailRepositoryProvider)
            .sendEmail(
              recipientEmail: recipients.value.join(','),
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
              isSendEnabled: recipients.value.isNotEmpty && !sending.value,
            ),
            _RecipientSection(recipients: recipients),
            _SubjectSection(controller: subject),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: body,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Message',
                  ),
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ),
            _FormattingToolbar(
              isFormattingActive: isFormattingActive.value,
              onToggleFormatting: () =>
                  isFormattingActive.value = !isFormattingActive.value,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class _RecipientSection extends HookWidget {
  const _RecipientSection({required this.recipients});
  final ValueNotifier<List<String>> recipients;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    void addRecipient(String value) {
      final email = value.trim().replaceAll(',', '').replaceAll(' ', '');
      if (email.isNotEmpty && !recipients.value.contains(email)) {
        recipients.value = [...recipients.value, email];
      }
      controller.clear();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'To:',
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...recipients.value.map(
                  (email) => InputChip(
                    label: Text(email),
                    backgroundColor: const Color(0xFFEEF2F7),
                    onDeleted: () {
                      recipients.value = recipients.value
                          .where((e) => e != email)
                          .toList();
                    },
                  ),
                ),
                IntrinsicWidth(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (val) {
                      if (val.endsWith(',') || val.endsWith(' ')) {
                        addRecipient(val);
                      }
                    },
                    onSubmitted: addRecipient,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectSection extends StatelessWidget {
  const _SubjectSection({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          const Text(
            'Subject:',
            style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormattingToolbar extends StatelessWidget {
  const _FormattingToolbar({
    required this.isFormattingActive,
    required this.onToggleFormatting,
  });

  final bool isFormattingActive;
  final VoidCallback onToggleFormatting;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFormattingActive)
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Text(
                    'B',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Text(
                    'I',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Text(
                    'U',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.list)),
              ],
            ),
          ),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onToggleFormatting,
                icon: Text(
                  'T',
                  style: TextStyle(
                    color: isFormattingActive
                        ? const Color(0xFF007AFF)
                        : Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.phone_outlined),
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.chat_bubble_outline),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
