import 'package:core_app/features/profile/widgets/sign_out_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SignOutButton renders correctly and handles tap', (
    tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SignOutButton(onTap: () => tapped = true)),
      ),
    );
    expect(find.text('Sign Out'), findsOneWidget);
    await tester.tap(find.text('Sign Out'));
    expect(tapped, isTrue);
  });
}
