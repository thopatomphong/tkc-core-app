import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_message.freezed.dart';
part 'email_message.g.dart';

@freezed
class EmailMessage with _$EmailMessage {
  const factory EmailMessage({
    required int id,
    required int senderId,
    required String senderUsername,
    required int recipientId,
    required String recipientUsername,
    required String subject,
    required String body,
    required DateTime createdAt,
  }) = _EmailMessage;

  factory EmailMessage.fromJson(Map<String, dynamic> json) =>
      _$EmailMessageFromJson(json);
}
