import 'package:core_app/models/auth_tokens.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef TokenLoader = Future<AuthTokens?> Function();
typedef NewEmailCallback = void Function(int emailId);
typedef OnlineUsersCallback = void Function(List<dynamic> data);

class WebSocketService {
  WebSocketService({
    required this.wsUrl,
    required this.loadTokens,
    this.onNewEmail,
    this.onOnlineUsers,
  });

  final String wsUrl;
  final TokenLoader loadTokens;
  final NewEmailCallback? onNewEmail;
  final OnlineUsersCallback? onOnlineUsers;

  io.Socket? _socket;

  Future<void> connect() async {
    final tokens = await loadTokens();
    if (tokens == null) return;
    final socket = io.io(
      wsUrl,
      io.OptionBuilder()
          .setTransports(<String>['websocket'])
          .enableReconnection()
          .setAuth(<String, dynamic>{'token': tokens.accessToken})
          .disableAutoConnect()
          .build(),
    );
    socket
      ..on('newEmail', (dynamic data) {
        final emailId = data is Map ? data['id'] : null;
        if (emailId is int) onNewEmail?.call(emailId);
      })
      ..on('onlineUsers', (dynamic data) {
        if (data is List) onOnlineUsers?.call(data);
      })
      ..connect();
    _socket = socket;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
