import 'package:core_app/features/profile/widgets/profile_header.dart';
import 'package:core_app/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileHeader displays user info and status badge', (
    tester,
  ) async {
    final user = Profile(
      id: 1,
      username: 'user1',
      displayName: 'User One',
      email: 'user1@mock.com',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ProfileHeader(user: user)),
      ),
    );

    expect(find.text('User One'), findsOneWidget);
    expect(find.text('@user1'), findsOneWidget);
    expect(find.text('user1@mock.com'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('U1'), findsOneWidget);
  });
}
