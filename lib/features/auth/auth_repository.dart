import 'package:core_app/core/network/api_exception.dart';
import 'package:core_app/models/auth_tokens.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  const AuthRepository(this._dio);
  final Dio _dio;

  Future<AuthTokens> login(String username, String password) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: <String, dynamic>{'username': username, 'password': password},
        options: Options(extra: <String, dynamic>{'skipAuth': true}),
      );
      return AuthTokens.fromJson(res.data!);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.statusCode == 401
            ? 'Invalid username or password'
            : 'Login failed. Check your connection.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
