import 'dart:async';

import 'package:core_app/models/auth_tokens.dart';
import 'package:dio/dio.dart';

typedef LoadTokens = Future<AuthTokens?> Function();
typedef SaveTokens = Future<void> Function(AuthTokens tokens);
typedef AuthFailureCallback = Future<void> Function();

/// Injects the bearer token and refreshes it on 401.
/// Refresh is single-flighted: concurrent 401s await the same future.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.loadTokens,
    required this.saveTokens,
    required this.onAuthFailure,
    required this.refreshDio,
  });

  final LoadTokens loadTokens;
  final SaveTokens saveTokens;
  final AuthFailureCallback onAuthFailure;

  /// A Dio used for the /auth/refresh call and request retries. In production
  /// this is the same app Dio; the `/auth/refresh` path is skipped by the
  /// refresh logic to avoid recursion.
  final Dio refreshDio;

  Future<AuthTokens?>? _inFlightRefresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }
    final tokens = await loadTokens();
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isRefreshCall = err.requestOptions.path.contains('/auth/refresh');
    if (err.response?.statusCode != 401 || isRefreshCall) {
      return handler.next(err);
    }
    if (err.requestOptions.extra['retried'] == true) {
      return handler.next(err);
    }

    final refreshed = await _refresh();
    if (refreshed == null) {
      await onAuthFailure();
      return handler.next(err);
    }

    try {
      final retried = await _retry(err.requestOptions, refreshed);
      return handler.resolve(retried);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Single-flight refresh: the first caller starts it, others await it.
  Future<AuthTokens?> _refresh() {
    return _inFlightRefresh ??= _doRefresh().whenComplete(() {
      _inFlightRefresh = null;
    });
  }

  Future<AuthTokens?> _doRefresh() async {
    final current = await loadTokens();
    if (current == null) return null;
    try {
      final res = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: <String, dynamic>{'refreshToken': current.refreshToken},
        options: Options(extra: <String, dynamic>{'skipAuth': true}),
      );
      final tokens = AuthTokens.fromJson(res.data!);
      await saveTokens(tokens);
      return tokens;
    } on DioException {
      return null;
    }
  }

  Future<Response<dynamic>> _retry(
    RequestOptions options,
    AuthTokens tokens,
  ) {
    options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    options.extra['retried'] = true;
    return refreshDio.fetch<dynamic>(options);
  }
}
