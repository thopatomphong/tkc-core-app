import 'dart:async';

import 'package:core_app/core/providers.dart';
import 'package:core_app/notifications/local_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_service.g.dart';

class FcmDeviceRegistrar {
  const FcmDeviceRegistrar({required this.dio, required this.deviceIdLoader});

  final Dio dio;
  final Future<String> Function() deviceIdLoader;

  Future<void> registerToken(String fcmToken) async {
    await dio.post<Map<String, dynamic>>(
      '/devices',
      data: <String, dynamic>{
        'deviceId': await deviceIdLoader(),
        'fcmToken': fcmToken,
      },
    );
  }

  Future<void> unregisterDevice() async {
    await dio.delete<Map<String, dynamic>>(
      '/devices',
      data: <String, dynamic>{'deviceId': await deviceIdLoader()},
    );
  }
}

class FcmService {
  FcmService({
    required this.messaging,
    required this.registrar,
    required this.localNotificationsLoader,
    this.foregroundMessages,
    this.tokenRefreshes,
  });

  final FirebaseMessaging messaging;
  final FcmDeviceRegistrar registrar;
  final Future<LocalNotifications> Function() localNotificationsLoader;
  final Stream<RemoteMessage>? foregroundMessages;
  final Stream<String>? tokenRefreshes;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;

  Future<void> registerDevice() async {
    try {
      await messaging.requestPermission();
      final token = await messaging.getToken();
      if (token == null) return;
      await registrar.registerToken(token);
    } catch (_) {
      return;
    }
  }

  Future<void> unregisterDevice() async {
    try {
      await registrar.unregisterDevice();
    } catch (_) {
      return;
    }
  }

  void startMessageHandlers() {
    if (_foregroundSubscription != null || _tokenRefreshSubscription != null) {
      return;
    }
    _foregroundSubscription =
        (foregroundMessages ?? FirebaseMessaging.onMessage).listen(
          showForeground,
        );
    _tokenRefreshSubscription = (tokenRefreshes ?? messaging.onTokenRefresh)
        .listen((token) async {
          try {
            await registrar.registerToken(token);
          } catch (_) {
            return;
          }
        });
  }

  Future<void> stopMessageHandlers() async {
    await _foregroundSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();
    _foregroundSubscription = null;
    _tokenRefreshSubscription = null;
  }

  Future<void> dispose() => stopMessageHandlers();

  Future<void> showForeground(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    final local = await localNotificationsLoader();
    await local.show(
      id: notification.hashCode,
      title: notification.title ?? 'New email',
      body: notification.body ?? '',
    );
  }
}

@Riverpod(keepAlive: true)
Future<LocalNotifications> localNotifications(LocalNotificationsRef ref) {
  return LocalNotifications.create();
}

@Riverpod(keepAlive: true)
FcmService fcmService(FcmServiceRef ref) {
  final dio = ref.watch(dioProvider);
  final deviceIdLoader = ref.watch(tokenStorageProvider).getOrCreateDeviceId;
  final service = FcmService(
    messaging: FirebaseMessaging.instance,
    registrar: FcmDeviceRegistrar(dio: dio, deviceIdLoader: deviceIdLoader),
    localNotificationsLoader: () =>
        ref.watch(localNotificationsProvider.future),
  );
  ref.onDispose(service.dispose);
  return service;
}
