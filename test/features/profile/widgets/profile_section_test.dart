import 'package:core_app/features/profile/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileSection displays label and children', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileSection(label: 'ACCOUNT', children: [Text('Child 1')]),
        ),
      ),
    );
    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('Child 1'), findsOneWidget);
  });
}
