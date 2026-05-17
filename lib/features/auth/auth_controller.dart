import 'package:core_app/core/providers.dart';
import 'package:core_app/features/auth/auth_repository.dart';
import 'package:core_app/models/auth_tokens.dart';
import 'package:core_app/notifications/fcm_service.dart';
import 'package:core_app/realtime/websocket_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(dioProvider));
}

/// Authentication status, exposed as an async value.
/// `true` = a valid session exists, `false` = logged out.
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<bool> build() async {
    // Log out automatically when a token refresh fails.
    ref.listen(authFailureSignalProvider, (prev, next) {
      if (prev != null && next > prev) {
        logout();
      }
    });

    final tokens = await ref.watch(tokenStorageProvider).readTokens();
    if (tokens == null) return false;
    final refreshAlive = tokens.refreshTokenExpiresAt.isAfter(
      DateTime.now().toUtc(),
    );
    if (!refreshAlive) {
      await ref.read(tokenStorageProvider).clearTokens();
      return false;
    }
    return true;
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final AuthTokens tokens = await ref
          .read(authRepositoryProvider)
          .login(username, password);
      await ref.read(tokenStorageProvider).saveTokens(tokens);
      return true;
    });
  }

  Future<void> logout() async {
    ref.read(webSocketServiceProvider).disconnect();
    await ref.read(fcmServiceProvider).unregisterDevice();
    await ref.read(tokenStorageProvider).clearTokens();
    state = const AsyncData(false);
  }
}
