import 'package:core_app/features/auth/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('login parses the token response', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    final adapter = DioAdapter(dio: dio);
    adapter.onPost(
      '/auth/login',
      (server) => server.reply(200, <String, dynamic>{
        'accessToken': 'a',
        'accessTokenExpiresAt': '2026-03-05T05:00:00.000Z',
        'refreshToken': 'r',
        'refreshTokenExpiresAt': '2026-03-06T04:30:00.000Z',
      }),
      data: <String, dynamic>{'username': 'user1', 'password': 'password'},
    );

    final repo = AuthRepository(dio);
    final tokens = await repo.login('user1', 'password');
    expect(tokens.accessToken, 'a');
    expect(tokens.refreshToken, 'r');
  });

  test('login throws ApiException on 401', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    final adapter = DioAdapter(dio: dio);
    adapter.onPost(
      '/auth/login',
      (server) => server.reply(401, <String, dynamic>{'message': 'bad creds'}),
      data: <String, dynamic>{'username': 'x', 'password': 'y'},
    );

    final repo = AuthRepository(dio);
    expect(() => repo.login('x', 'y'), throwsA(isA<Exception>()));
  });
}
