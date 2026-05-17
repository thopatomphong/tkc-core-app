import 'package:core_app/core/env/env.dart';
import 'package:core_app/core/network/auth_interceptor.dart';
import 'package:core_app/core/storage/token_storage.dart';
import 'package:dio/dio.dart';

/// Builds the app-wide Dio. `onAuthFailure` is invoked when a refresh fails
/// (the caller wires it to logout).
Dio buildAuthedDio({
  required TokenStorage storage,
  required Future<void> Function() onAuthFailure,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(
      loadTokens: storage.readTokens,
      saveTokens: storage.saveTokens,
      onAuthFailure: onAuthFailure,
      refreshDio: dio,
    ),
  );
  return dio;
}
