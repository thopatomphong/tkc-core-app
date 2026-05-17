import 'dart:convert';
import 'dart:typed_data';

import 'package:core_app/core/network/auth_interceptor.dart';
import 'package:core_app/models/auth_tokens.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

AuthTokens _tokens(String access) => AuthTokens(
  accessToken: access,
  accessTokenExpiresAt: DateTime.utc(2026, 3, 5, 5),
  refreshToken: 'refresh-1',
  refreshTokenExpiresAt: DateTime.utc(2030),
);

/// A fully-scripted HttpClientAdapter so each request's response is
/// deterministic — http_mock_adapter cannot vary one route by call count.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.onFetch);
  final Future<ResponseBody> Function(RequestOptions) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => onFetch(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Map<String, dynamic> body) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>['application/json'],
      },
    );

void main() {
  test('injects the bearer access token on outgoing requests', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    String? seenHeader;
    dio.httpClientAdapter = _ScriptedAdapter((options) async {
      seenHeader = options.headers['Authorization'] as String?;
      return _json(200, <String, dynamic>{'ok': true});
    });
    dio.interceptors.add(
      AuthInterceptor(
        loadTokens: () async => _tokens('access-1'),
        saveTokens: (_) async {},
        onAuthFailure: () async {},
        refreshDio: dio,
      ),
    );

    final res = await dio.get<dynamic>('/account/profile');
    expect(res.statusCode, 200);
    expect(seenHeader, 'Bearer access-1');
  });

  test('on 401 it refreshes once and retries the original request', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    var refreshCalls = 0;
    var inboxCalls = 0;
    AuthTokens current = _tokens('expired');

    dio.httpClientAdapter = _ScriptedAdapter((options) async {
      if (options.path == '/auth/refresh') {
        refreshCalls++;
        return _json(200, <String, dynamic>{
          'accessToken': 'fresh',
          'accessTokenExpiresAt': '2030-01-01T00:00:00.000Z',
          'refreshToken': 'refresh-2',
          'refreshTokenExpiresAt': '2030-01-02T00:00:00.000Z',
        });
      }
      inboxCalls++;
      // First /email/inbox call fails with 401; the post-refresh retry wins.
      return inboxCalls == 1
          ? _json(401, <String, dynamic>{})
          : _json(200, <String, dynamic>{'total': 0, 'data': <dynamic>[]});
    });

    dio.interceptors.add(
      AuthInterceptor(
        loadTokens: () async => current,
        saveTokens: (t) async => current = t,
        onAuthFailure: () async {},
        refreshDio: dio,
      ),
    );

    final res = await dio.get<dynamic>('/email/inbox');
    expect(res.statusCode, 200);
    expect(refreshCalls, 1);
    expect(current.accessToken, 'fresh');
  });
}
