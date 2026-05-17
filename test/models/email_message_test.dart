import 'package:core_app/models/email_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('EmailMessage parses the inbox item shape', () {
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
    final email = EmailMessage.fromJson(json);
    expect(email.id, 1);
    expect(email.senderUsername, 'system');
    expect(email.createdAt.year, 2026);
  });
}
