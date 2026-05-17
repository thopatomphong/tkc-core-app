import 'package:core_app/features/profile/widgets/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileTile displays title and value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileTile(
            icon: Icons.person,
            iconColor: Colors.blue,
            title: 'Display Name',
            value: 'User One',
          ),
        ),
      ),
    );
    expect(find.text('Display Name'), findsOneWidget);
    expect(find.text('User One'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
