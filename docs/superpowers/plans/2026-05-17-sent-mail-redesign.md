# Sent Mail Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refine the Mail screen to support dynamic headers and status indicators (green double-checks) in the Sent tab.

**Architecture:** 
- `EmailTile`: Updated to conditionally show a status icon.
- `InboxScreen`: Refactored to listen to `TabController` for title updates.

**Tech Stack:** Flutter, Riverpod, Hooks.

---

### Task 1: Update `EmailTile` status icon

**Files:**
- Modify: `lib/features/mail/widgets/email_tile.dart`
- Test: `test/features/mail/widgets/email_tile_test.dart`

- [ ] **Step 1: Write the failing test**
Update the test to verify that the `Icons.done_all` icon is present in `isSentMode`.
```dart
testWidgets('EmailTile displays status icon in sent mode', (tester) async {
  final email = EmailMessage(
    id: 1,
    senderId: 10,
    senderUsername: 'system',
    recipientId: 1,
    recipientUsername: 'user',
    subject: 'Subject',
    body: 'Body',
    createdAt: DateTime.now(),
  );

  await tester.pumpWidget(MaterialApp(home: Scaffold(body: EmailTile(email: email, isSentMode: true))));
  expect(find.byIcon(Icons.done_all), findsOneWidget);
});
```

- [ ] **Step 2: Run test to verify it fails**
Run: `flutter test test/features/mail/widgets/email_tile_test.dart`
Expected: FAIL

- [ ] **Step 3: Implement status icon**
```dart
// lib/features/mail/widgets/email_tile.dart
// Update Row in Title section:
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    Row(
      children: [
        Text(formatRelativeTime(email.createdAt), style: const TextStyle(color: Colors.grey, fontSize: 13)),
        if (isSentMode) ...[
          const SizedBox(width: 4),
          const Icon(Icons.done_all, color: Color(0xFF4CAF50), size: 16),
        ],
      ],
    ),
  ],
),
```

- [ ] **Step 4: Run test to verify it passes**
Run: `flutter test test/features/mail/widgets/email_tile_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**
```bash
git add lib/features/mail/widgets/email_tile.dart test/features/mail/widgets/email_tile_test.dart
git commit -m "feat: add status icon to EmailTile in sent mode"
```

---

### Task 2: Dynamic Header in `InboxScreen`

**Files:**
- Modify: `lib/features/mail/inbox_screen.dart`

- [ ] **Step 1: Refactor to listen to TabController**
We'll use `flutter_hooks` (already in the project via `hooks_riverpod` often implies it, but I'll use a standard `StatefulWidget` or `ConsumerStatefulWidget` to be safe if `useTabController` isn't available, or just wrap the Title in a builder).
Actually, `DefaultTabController` is being used. I will wrap the Header in a `Builder` and listen to the controller.

```dart
// lib/features/mail/inbox_screen.dart
// Inside build method, wrap the Title in a widget that listens to the controller:

// 1. Change InboxScreen to ConsumerStatefulWidget or use a local listener.
// Let's use a local Hook since the project uses hooks_riverpod.

// If we want to keep DefaultTabController, we can't easily listen to it from the same build method without a Builder.
```

Revised Step 1 implementation using a `StatefulWidget` for simpler controller management:
```dart
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<_InboxScreenState> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _title = 'Inbox';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != (_title == 'Inbox' ? 0 : 1)) {
        setState(() {
          _title = _tabController.index == 0 ? 'Inbox' : 'Sent';
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Replace DefaultTabController with Scaffold containing _tabController
  }
}
```

- [ ] **Step 2: Update UI with dynamic title**
```dart
Text(_title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
```

- [ ] **Step 3: Verify visually and with a test**
- [ ] **Step 4: Commit**
```bash
git add lib/features/mail/inbox_screen.dart
git commit -m "feat: make Inbox screen title dynamic"
```
