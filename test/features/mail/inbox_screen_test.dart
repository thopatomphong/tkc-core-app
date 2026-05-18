import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/presentation/providers/mail_providers.dart';
import 'package:core_app/features/mail/presentation/screens/inbox_screen.dart';
import 'package:core_app/features/mail/presentation/widgets/mail_list_view.dart';
import 'package:core_app/models/paginated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  final inboxMessage = EmailMessage(
    id: 42,
    senderId: 1,
    senderUsername: 'system',
    recipientId: 2,
    recipientUsername: 'user1',
    subject: 'Welcome aboard',
    body: 'Your mailbox is ready.',
    createdAt: DateTime(2026, 1, 1),
  );

  Future<void> pumpInboxRoute(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/mail',
      routes: [
        GoRoute(
          path: '/mail',
          builder: (context, state) => const InboxScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => const Scaffold(body: Text('detail')),
            ),
          ],
        ),
        GoRoute(
          path: '/compose',
          builder: (context, state) => const Scaffold(body: Text('compose')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inboxProvider(page: 1).overrideWith(
            (ref) async => Paginated(total: 1, items: [inboxMessage]),
          ),
          sentMailProvider(page: 1).overrideWith(
            (ref) async => const Paginated<EmailMessage>(total: 0, items: []),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('tapping compose opens root compose route', (tester) async {
    await pumpInboxRoute(tester);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.text('compose'), findsOneWidget);
  });

  testWidgets('tapping an email tile opens detail route', (tester) async {
    await pumpInboxRoute(tester);

    await tester.tap(find.text('Welcome aboard'));
    await tester.pumpAndSettle();

    expect(find.text('detail'), findsOneWidget);
  });

  testWidgets('mail list paginates with next and previous buttons', (
    tester,
  ) async {
    final pageOneEmail = EmailMessage(
      id: 100,
      senderId: 1,
      senderUsername: 'system',
      recipientId: 2,
      recipientUsername: 'user1',
      subject: 'Page one',
      body: 'First page message.',
      createdAt: DateTime(2026, 1, 1),
    );
    final pageTwoEmail = EmailMessage(
      id: 101,
      senderId: 1,
      senderUsername: 'system',
      recipientId: 2,
      recipientUsername: 'user1',
      subject: 'Page two',
      body: 'Second page message.',
      createdAt: DateTime(2026, 1, 2),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inboxProvider(page: 1).overrideWith(
            (ref) async => Paginated(total: 11, items: [pageOneEmail]),
          ),
          inboxProvider(page: 2).overrideWith(
            (ref) async => Paginated(total: 11, items: [pageTwoEmail]),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: MailListView(provider: inboxProvider.call)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Page one'), findsOneWidget);
    expect(find.text('Page 1 of 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Next page'));
    await tester.pumpAndSettle();

    expect(find.text('Page two'), findsOneWidget);
    expect(find.text('Page 2 of 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Previous page'));
    await tester.pumpAndSettle();

    expect(find.text('Page one'), findsOneWidget);
    expect(find.text('Page 1 of 2'), findsOneWidget);
  });
}
