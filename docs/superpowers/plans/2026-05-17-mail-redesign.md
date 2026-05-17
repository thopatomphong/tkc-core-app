# Mail Detail Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the Mail Detail screen to show a structured "Order Receipt" card as per the mockup.

**Architecture:** The UI will be decomposed into private stateless widgets (`_EmailHeader`, `_ReceiptCard`, `_ReceiptItem`) within the `email_detail_screen.dart` file. This promotes readability and follows the "Componentized Layout" approach approved during brainstorming.

**Tech Stack:** Flutter, Riverpod (for data), Hooks (if applicable, but staying with standard widgets for now).

---

### Task 1: Create Baseline Widget Test

**Files:**
- Create: `test/features/mail/email_detail_screen_test.dart`

- [ ] **Step 1: Write a baseline test for the current screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_app/features/mail/email_detail_screen.dart';
import 'package:core_app/features/mail/mail_providers.dart';
import 'package:core_app/models/email_message.dart';

void main() {
  testWidgets('EmailDetailScreen shows basic email info', (tester) async {
    final message = EmailMessage(
      id: 1,
      senderId: 1,
      senderUsername: 'system',
      recipientId: 2,
      recipientUsername: 'user1',
      subject: 'Order #3 Receipt',
      body: 'Your order is ready.',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          emailDetailProvider(1).overrideWith((ref) => AsyncData(message)),
        ],
        child: const MaterialApp(
          home: EmailDetailScreen(emailId: 1),
        ),
      ),
    );

    expect(find.text('Order #3 Receipt'), findsOneWidget);
    expect(find.text('From: system'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify baseline**

Run: `flutter test test/features/mail/email_detail_screen_test.dart`
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add test/features/mail/email_detail_screen_test.dart
git commit -m "test: add baseline test for EmailDetailScreen"
```

### Task 2: Implement `_EmailHeader` Component

**Files:**
- Modify: `lib/features/mail/email_detail_screen.dart`

- [ ] **Step 1: Define `_EmailHeader` private widget**

Add this at the bottom of the file:

```dart
class _EmailHeader extends StatelessWidget {
  const _EmailHeader({required this.message});
  final EmailMessage message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.subject,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Text(
                message.senderUsername[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderUsername,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'To: ${message.recipientUsername} · Just now',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Update `EmailDetailScreen` to use `_EmailHeader`**

Replace the children of the `ListView` in the `data` state:

```dart
        data: (message) => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _EmailHeader(message: message),
            // ... more to come
          ],
        ),
```

- [ ] **Step 3: Update test and verify**

Modify `test/features/mail/email_detail_screen_test.dart` to check for the new header structure (e.g., `CircleAvatar`).

```bash
flutter test test/features/mail/email_detail_screen_test.dart
```

- [ ] **Step 4: Commit**

```bash
git add lib/features/mail/email_detail_screen.dart
git commit -m "feat: implement _EmailHeader in EmailDetailScreen"
```

### Task 3: Implement `_ReceiptItem` Component

**Files:**
- Modify: `lib/features/mail/email_detail_screen.dart`

- [ ] **Step 1: Define `_ReceiptItem` private widget**

```dart
class _ReceiptItem extends StatelessWidget {
  const _ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 14)),
              Text(
                '× $quantity',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          Text(price, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/mail/email_detail_screen.dart
git commit -m "feat: add _ReceiptItem widget"
```

### Task 4: Implement `_ReceiptCard` Component

**Files:**
- Modify: `lib/features/mail/email_detail_screen.dart`

- [ ] **Step 1: Define `_ReceiptCard` private widget**

```dart
class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🧾 ', style: TextStyle(fontSize: 16)),
              Text(
                'Order Receipt',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 32),
          const _ReceiptItem(
            name: 'Apple AirPods',
            quantity: 2,
            price: '฿8,980',
          ),
          const _ReceiptItem(
            name: 'Apple MagSafe Battery',
            quantity: 1,
            price: '฿3,490',
          ),
          const Divider(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '฿12,470',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'March 5, 2026 at 10:32 AM',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Assemble full screen**

Update `EmailDetailScreen` build method:

```dart
        data: (message) => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _EmailHeader(message: message),
            const _ReceiptCard(),
          ],
        ),
```

- [ ] **Step 3: Final verification and commit**

Run: `flutter test test/features/mail/email_detail_screen_test.dart`
Ensure all elements are present.

```bash
git add lib/features/mail/email_detail_screen.dart
git commit -m "feat: complete Mail Detail redesign with _ReceiptCard"
```
