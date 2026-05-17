# Compose Email Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the `ComposeScreen` with a high-fidelity iOS aesthetic, componentized private widgets, multiple recipient support (chips), and a functional formatting toolbar.

**Architecture:** Refactor `ComposeScreen` into focused private widgets (`_ComposeHeader`, `_RecipientSection`, `_SubjectSection`, `_BodyArea`, `_FormattingToolbar`). Update `MailRepository` to handle multiple recipients. Use `flutter_hooks` for local UI state.

**Tech Stack:** Flutter, Hooks, Riverpod, Dio.

---

### Task 1: Update MailRepository for Multiple Recipients

**Files:**
- Modify: `lib/features/mail/mail_repository.dart`
- Modify: `test/features/mail/mail_repository_test.dart`

- [ ] **Step 1: Update sendEmail signature and payload**
Modify `lib/features/mail/mail_repository.dart`:
```dart
  Future<EmailMessage> sendEmail({
    required List<String> recipientEmails,
    required String subject,
    required String body,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/email',
      data: <String, dynamic>{
        'recipientEmails': recipientEmails, // Changed to plural
        'subject': subject,
        'body': body,
      },
    );
    return EmailMessage.fromJson(res.data!);
  }
```

- [ ] **Step 2: Update repository tests**
Modify `test/features/mail/mail_repository_test.dart` to use a list of emails.

- [ ] **Step 3: Verify repository tests pass**
Run: `flutter test test/features/mail/mail_repository_test.dart`

- [ ] **Step 4: Commit**
```bash
git add lib/features/mail/mail_repository.dart test/features/mail/mail_repository_test.dart
git commit -m "refactor: support multiple recipients in MailRepository"
```

### Task 2: Create ComposeScreen Baseline Test

**Files:**
- Create: `test/features/mail/compose_screen_test.dart`

- [ ] **Step 1: Write a baseline widget test**
Create `test/features/mail/compose_screen_test.dart` to verify current screen (it will fail after refactor, but we need a starting point).
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_app/features/mail/compose_screen.dart';

void main() {
  testWidgets('ComposeScreen shows basic fields', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ComposeScreen()),
      ),
    );
    expect(find.text('Compose'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Verify test passes**
Run: `flutter test test/features/mail/compose_screen_test.dart`

- [ ] **Step 3: Commit**
```bash
git add test/features/mail/compose_screen_test.dart
git commit -m "test: add baseline for ComposeScreen"
```

### Task 3: Implement _ComposeHeader and Base Refactor

**Files:**
- Modify: `lib/features/mail/compose_screen.dart`

- [ ] **Step 1: Refactor ComposeScreen to Column layout and add _ComposeHeader**
Replace `AppBar` with `null` and wrap body in a `Column`. Add `_ComposeHeader` at the bottom of the file.
```dart
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
```

- [ ] **Step 2: Update ComposeScreen to use _ComposeHeader**
Modify `ComposeScreen` to use `_ComposeHeader` and remove the old `AppBar`.

- [ ] **Step 3: Commit**
```bash
git add lib/features/mail/compose_screen.dart
git commit -m "feat: implement _ComposeHeader in ComposeScreen"
```

### Task 4: Implement _RecipientSection with Chips

**Files:**
- Modify: `lib/features/mail/compose_screen.dart`

- [ ] **Step 1: Add _RecipientSection private widget**
Implement chip logic using `InputChip` and a `Wrap`.
```dart
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
            child: Text('To:', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...recipients.value.map((email) => InputChip(
                  label: Text(email),
                  backgroundColor: const Color(0xFFEEF2F7),
                  onDeleted: () {
                    recipients.value = recipients.value.where((e) => e != email).toList();
                  },
                )),
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
```

- [ ] **Step 2: Integrate _RecipientSection into ComposeScreen**
Update `ComposeScreen` to use `_RecipientSection` and provide the `recipients` notifier.

- [ ] **Step 3: Commit**
```bash
git add lib/features/mail/compose_screen.dart
git commit -m "feat: add _RecipientSection with chips to ComposeScreen"
```

### Task 5: Implement _SubjectSection, _BodyArea, and _FormattingToolbar

**Files:**
- Modify: `lib/features/mail/compose_screen.dart`

- [ ] **Step 1: Add _SubjectSection, _BodyArea, and _FormattingToolbar widgets**
Implement the remaining UI components at the bottom of the file.
```dart
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
          const Text('Subject:', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16)),
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
                IconButton(onPressed: () {}, icon: const Text('B', style: TextStyle(fontWeight: FontWeight.bold))),
                IconButton(onPressed: () {}, icon: const Text('I', style: TextStyle(fontStyle: FontStyle.italic))),
                IconButton(onPressed: () {}, icon: const Text('U', style: TextStyle(decoration: TextDecoration.underline))),
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
                    color: isFormattingActive ? const Color(0xFF007AFF) : Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const IconButton(onPressed: null, icon: Icon(Icons.phone_outlined)),
              const IconButton(onPressed: null, icon: Icon(Icons.chat_bubble_outline)),
            ],
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Final assembly in ComposeScreen**
Assemble all components in the `ComposeScreen`'s `build` method.
```dart
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
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Message'),
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ),
            _FormattingToolbar(
              isFormattingActive: isFormattingActive.value,
              onToggleFormatting: () => isFormattingActive.value = !isFormattingActive.value,
            ),
          ],
        ),
      ),
    );
```

- [ ] **Step 3: Update widget tests**
Update `test/features/mail/compose_screen_test.dart` to verify new components.
```dart
    expect(find.text('New Email'), findsOneWidget);
    expect(find.text('To:'), findsOneWidget);
    expect(find.text('Subject:'), findsOneWidget);
```

- [ ] **Step 4: Run all tests**
Run: `flutter test`

- [ ] **Step 5: Commit**
```bash
git add lib/features/mail/compose_screen.dart test/features/mail/compose_screen_test.dart
git commit -m "feat: complete ComposeScreen redesign with formatting toolbar"
```
