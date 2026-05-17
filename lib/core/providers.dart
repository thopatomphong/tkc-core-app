import 'package:core_app/core/network/dio_client.dart';
import 'package:core_app/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Secure storage — overridable in tests.
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

/// The app-wide authenticated Dio. On auth failure it bumps a signal that
/// the AuthController listens to in order to log out.
final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  return buildAuthedDio(
    storage: storage,
    onAuthFailure: () async {
      ref.read(authFailureSignalProvider.notifier).state++;
    },
  );
});

/// Bumped whenever a token refresh fails; AuthController listens and logs out.
final authFailureSignalProvider = StateProvider<int>((ref) => 0);
