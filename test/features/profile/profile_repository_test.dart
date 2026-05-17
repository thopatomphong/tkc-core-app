import 'package:core_app/features/profile/profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('getProfile calls the assignment account profile endpoint', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    final adapter = DioAdapter(dio: dio);
    adapter.onGet(
      '/account/profile',
      (server) => server.reply(200, <String, dynamic>{
        'id': 1,
        'username': 'user1',
        'email': 'user1@mock.com',
        'displayName': 'User One',
      }),
    );

    final profile = await ProfileRepository(dio).getProfile();

    expect(profile.email, 'user1@mock.com');
  });
}
