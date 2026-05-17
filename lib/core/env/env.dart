import 'dart:io';

/// Resolves the mock-server host for the current platform.
/// Android emulators reach the host machine via 10.0.2.2; iOS simulators
/// use localhost directly.
class Env {
  const Env._();

  static String get _host => Platform.isAndroid ? '10.0.2.2' : 'localhost';

  static String get apiBaseUrl => 'http://$_host:3000';

  static String get wsUrl => 'http://$_host:3000/ws';
}
