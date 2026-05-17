import 'package:core_app/models/profile.dart';
import 'package:dio/dio.dart';

class ProfileRepository {
  const ProfileRepository(this._dio);

  final Dio _dio;

  Future<Profile> getProfile() async {
    final res = await _dio.get<Map<String, dynamic>>('/account/profile');
    return Profile.fromJson(res.data!);
  }
}
