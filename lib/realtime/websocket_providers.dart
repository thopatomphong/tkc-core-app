import 'package:core_app/core/env/env.dart';
import 'package:core_app/core/providers.dart';
import 'package:core_app/features/mail/presentation/providers/mail_providers.dart';
import 'package:core_app/models/online_user.dart';
import 'package:core_app/realtime/websocket_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_providers.g.dart';

@Riverpod(keepAlive: true)
class OnlineUsers extends _$OnlineUsers {
  @override
  List<OnlineUser> build() => [];

  void updateUsers(List<dynamic> data) {
    state = data
        .whereType<Map<String, dynamic>>()
        .map(OnlineUser.fromJson)
        .toList();
  }
}

@Riverpod(keepAlive: true)
WebSocketService webSocketService(WebSocketServiceRef ref) {
  final service = WebSocketService(
    wsUrl: Env.wsUrl,
    loadTokens: ref.watch(tokenStorageProvider).readTokens,
    onNewEmail: (_) => ref.invalidate(inboxProvider()),
    onOnlineUsers: (data) {
      ref.read(onlineUsersProvider.notifier).updateUsers(data);
    },
  );
  ref.onDispose(service.disconnect);
  return service;
}

@Riverpod(keepAlive: true)
Future<void> webSocketController(WebSocketControllerRef ref) {
  return ref.watch(webSocketServiceProvider).connect();
}
