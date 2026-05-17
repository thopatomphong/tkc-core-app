import 'package:core_app/features/mail/data/dtos/email_message_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('EmailMessageDto parses inbox item shape and maps to entity', () {
    final json = <String, dynamic>{
      'id': 1,
      'senderId': 0,
      'senderUsername': 'system',
      'recipientId': 1,
      'recipientUsername': 'user1',
      'subject': 'Test Push',
      'body': 'Hello!',
      'createdAt': '2026-03-05T04:30:00.000Z',
    };

    final dto = EmailMessageDto.fromJson(json);
    expect(dto.id, 1);
    expect(dto.senderUsername, 'system');
    expect(dto.createdAt.year, 2026);

    final entity = dto.toEntity();
    expect(entity.id, 1);
    expect(entity.senderUsername, 'system');
    expect(entity.subject, 'Test Push');
  });
}
