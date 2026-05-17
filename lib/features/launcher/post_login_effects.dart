import 'package:core_app/features/auth/auth_controller.dart';
import 'package:core_app/notifications/fcm_service.dart';
import 'package:core_app/realtime/websocket_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_login_effects.g.dart';

@riverpod
Future<void> postLoginEffects(PostLoginEffectsRef ref) async {
  final loggedIn = await ref.watch(authControllerProvider.future);
  if (!loggedIn) return;
  final fcm = ref.watch(fcmServiceProvider);
  var disposed = false;
  ref.onDispose(() {
    disposed = true;
    fcm.stopMessageHandlers();
  });
  await fcm.registerDevice();
  if (disposed) return;
  fcm.startMessageHandlers();
  ref.watch(webSocketControllerProvider);
}
