import 'package:core_app/core/providers.dart';
import 'package:core_app/core/storage/token_storage.dart';
import 'package:core_app/features/auth/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('build returns false when no tokens are stored', () async {
    final container = ProviderContainer(
      overrides: <Override>[
        tokenStorageProvider.overrideWithValue(
          TokenStorage.forTesting(<String, String>{}),
        ),
      ],
    );
    addTearDown(container.dispose);

    final loggedIn = await container.read(authControllerProvider.future);
    expect(loggedIn, isFalse);
  });
}
