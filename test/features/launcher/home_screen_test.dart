import 'package:core_app/features/launcher/home_screen.dart';
import 'package:core_app/features/launcher/widgets/home_header.dart';
import 'package:core_app/features/launcher/widgets/mini_app_card.dart';
import 'package:core_app/models/profile.dart';
import 'package:core_app/features/profile/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('HomeScreen displays greeting and mini app cards', (
    tester,
  ) async {
    final mockProfile = Profile(
      id: 1,
      username: 'userone',
      email: 'userone@example.com',
      displayName: 'User One',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [profileProvider.overrideWith((ref) => mockProfile)],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('Good morning,'), findsOneWidget);
    expect(find.text('User One'), findsOneWidget);
    expect(find.text('Mini Apps'), findsOneWidget);
    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('Concert'), findsOneWidget);
    expect(find.byType(MiniAppCard), findsNWidgets(2));
    expect(find.byType(HomeHeader), findsOneWidget);
  });
}
