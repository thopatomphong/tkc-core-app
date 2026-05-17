import 'package:core_app/core/env/env.dart';
import 'package:core_app/core/providers.dart';
import 'package:core_app/features/mail/mail_providers.dart';
import 'package:core_app/realtime/websocket_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_providers.g.dart';

@Riverpod(keepAlive: true)
WebSocketService webSocketService(WebSocketServiceRef ref) {
  final service = WebSocketService(
    wsUrl: Env.wsUrl,
    loadTokens: ref.watch(tokenStorageProvider).readTokens,
    onNewEmail: (_) => ref.invalidate(inboxProvider()),
  );
  ref.onDispose(service.disconnect);
  return service;
}

@Riverpod(keepAlive: true)
Future<void> webSocketController(WebSocketControllerRef ref) {
  return ref.watch(webSocketServiceProvider).connect();
}
