import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_message_dto.freezed.dart';
part 'email_message_dto.g.dart';

@freezed
class EmailMessageDto with _$EmailMessageDto {
  const factory EmailMessageDto({
    required int id,
    required int senderId,
    required String senderUsername,
    required int recipientId,
    required String recipientUsername,
    required String subject,
    required String body,
    required DateTime createdAt,
  }) = _EmailMessageDto;

  factory EmailMessageDto.fromJson(Map<String, dynamic> json) =>
      _$EmailMessageDtoFromJson(json);
}

extension EmailMessageDtoMapper on EmailMessageDto {
  EmailMessage toEntity() => EmailMessage(
        id: id,
        senderId: senderId,
        senderUsername: senderUsername,
        recipientId: recipientId,
        recipientUsername: recipientUsername,
        subject: subject,
        body: body,
        createdAt: createdAt,
      );
}
