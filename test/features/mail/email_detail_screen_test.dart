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
          emailDetailProvider(1).overrideWith((ref) => message),
        ],
        child: const MaterialApp(
          home: EmailDetailScreen(emailId: 1),
        ),
      ),
    );

    expect(find.text('Order #3 Receipt'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('system'), findsOneWidget);
    expect(find.text('Apple AirPods'), findsOneWidget);
    expect(find.text('Apple MagSafe Battery'), findsOneWidget);
    expect(find.text('฿12,470'), findsOneWidget);
  });
}
