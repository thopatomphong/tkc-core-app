import 'package:core_app/core/storage/token_storage.dart';
import 'package:core_app/models/auth_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saveTokens then readTokens returns the same tokens', () async {
    final store = <String, String>{};
    final storage = TokenStorage.forTesting(store);
    final tokens = AuthTokens(
      accessToken: 'a',
      accessTokenExpiresAt: DateTime.utc(2026, 3, 5, 5),
      refreshToken: 'r',
      refreshTokenExpiresAt: DateTime.utc(2026, 3, 6, 4, 30),
    );

    await storage.saveTokens(tokens);
    final read = await storage.readTokens();

    expect(read, isNotNull);
    expect(read!.accessToken, 'a');
    expect(read.refreshToken, 'r');
  });

  test('readTokens returns null when nothing stored', () async {
    final storage = TokenStorage.forTesting(<String, String>{});
    expect(await storage.readTokens(), isNull);
  });

  test('getOrCreateDeviceId is stable across calls', () async {
    final storage = TokenStorage.forTesting(<String, String>{});
    final first = await storage.getOrCreateDeviceId();
    final second = await storage.getOrCreateDeviceId();
    expect(first, second);
    expect(first, isNotEmpty);
  });

  test('clear removes tokens but keeps the deviceId', () async {
    final storage = TokenStorage.forTesting(<String, String>{});
    final deviceId = await storage.getOrCreateDeviceId();
    await storage.saveTokens(
      AuthTokens(
        accessToken: 'a',
        accessTokenExpiresAt: DateTime.utc(2026),
        refreshToken: 'r',
        refreshTokenExpiresAt: DateTime.utc(2026),
      ),
    );
    await storage.clearTokens();
    expect(await storage.readTokens(), isNull);
    expect(await storage.getOrCreateDeviceId(), deviceId);
  });
}
