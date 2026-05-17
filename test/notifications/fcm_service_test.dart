import 'dart:async';

import 'package:core_app/notifications/fcm_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void main() {
  test('registerToken posts assignment /devices payload', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    final adapter = DioAdapter(dio: dio);
    adapter.onPost(
      '/devices',
      (server) => server.reply(201, <String, dynamic>{'ok': true}),
      data: <String, dynamic>{
        'deviceId': 'device-1',
        'fcmToken': 'fcm-token-1',
      },
    );

    final service = FcmDeviceRegistrar(
      dio: dio,
      deviceIdLoader: () async => 'device-1',
    );

    await service.registerToken('fcm-token-1');
  });

  test('unregisterDevice sends assignment DELETE /devices body', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    final adapter = DioAdapter(dio: dio);
    adapter.onDelete(
      '/devices',
      (server) => server.reply(200, <String, dynamic>{'ok': true}),
      data: <String, dynamic>{'deviceId': 'device-1'},
    );

    final service = FcmDeviceRegistrar(
      dio: dio,
      deviceIdLoader: () async => 'device-1',
    );

    await service.unregisterDevice();
  });

  test('startMessageHandlers is idempotent for token refresh', () async {
    final tokenRefreshes = StreamController<String>();
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    final requests = <RequestOptions>[];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          handler.resolve(Response<dynamic>(requestOptions: options, data: {}));
        },
      ),
    );
    final service = FcmService(
      messaging: _MockFirebaseMessaging(),
      registrar: FcmDeviceRegistrar(
        dio: dio,
        deviceIdLoader: () async => 'device-1',
      ),
      localNotificationsLoader: () => throw UnimplementedError(),
      tokenRefreshes: tokenRefreshes.stream,
      foregroundMessages: const Stream<RemoteMessage>.empty(),
    );
    addTearDown(() async {
      await service.stopMessageHandlers();
      await tokenRefreshes.close();
    });

    service.startMessageHandlers();
    service.startMessageHandlers();
    tokenRefreshes.add('fcm-token-1');
    await pumpEventQueue();

    expect(requests, hasLength(1));
    expect(requests.single.path, '/devices');
    expect(requests.single.data, <String, dynamic>{
      'deviceId': 'device-1',
      'fcmToken': 'fcm-token-1',
    });
  });

  test('token refresh registration errors are ignored', () async {
    final tokenRefreshes = StreamController<String>();
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    final service = FcmService(
      messaging: _MockFirebaseMessaging(),
      registrar: FcmDeviceRegistrar(
        dio: dio,
        deviceIdLoader: () async => 'device-1',
      ),
      localNotificationsLoader: () => throw UnimplementedError(),
      tokenRefreshes: tokenRefreshes.stream,
      foregroundMessages: const Stream<RemoteMessage>.empty(),
    );
    addTearDown(() async {
      await service.stopMessageHandlers();
      await tokenRefreshes.close();
    });

    final errors = <Object>[];
    await runZonedGuarded(() async {
      service.startMessageHandlers();
      tokenRefreshes.add('fcm-token-1');
      await pumpEventQueue();
    }, (error, stackTrace) => errors.add(error));

    expect(errors, isEmpty);
  });
}
