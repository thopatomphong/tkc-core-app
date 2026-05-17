import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_app/features/mail/presentation/screens/compose_screen.dart';

void main() {
  testWidgets('ComposeScreen shows basic fields', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ComposeScreen())),
    );
    expect(find.text('New Email'), findsOneWidget);
    expect(find.text('To:'), findsOneWidget);
    expect(find.text('Subject:'), findsOneWidget);
    expect(find.text('T'), findsOneWidget);
  });
}
