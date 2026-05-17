import 'package:core_app/features/mail/widgets/email_tile.dart';
import 'package:core_app/models/email_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EmailTile displays sender and subject', (tester) async {
    final email = EmailMessage(
      id: 1,
      senderId: 10,
      senderUsername: 'system',
      recipientId: 1,
      recipientUsername: 'user',
      subject: 'Order Receipt',
      body: 'Thank you for your order!',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: EmailTile(email: email)),
      ),
    );
    expect(find.text('system'), findsOneWidget);
    expect(find.text('Order Receipt'), findsOneWidget);
  });

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

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: EmailTile(email: email, isSentMode: true)),
      ),
    );
    expect(find.byIcon(Icons.done_all), findsOneWidget);
  });
}
