import 'package:freezed_annotation/freezed_annotation.dart';

part 'online_user.freezed.dart';
part 'online_user.g.dart';

@freezed
class OnlineUser with _$OnlineUser {
  const factory OnlineUser({
    required int id,
    required String username,
    required String displayName,
  }) = _OnlineUser;

  factory OnlineUser.fromJson(Map<String, dynamic> json) =>
      _$OnlineUserFromJson(json);
}
