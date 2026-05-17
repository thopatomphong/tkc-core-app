import 'package:core_app/features/mail/mail_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Map<String, dynamic> _emailJson(int id) => <String, dynamic>{
  'id': id,
  'senderId': 1,
  'senderUsername': 'user1',
  'recipientId': 2,
  'recipientUsername': 'user2',
  'subject': 'Hello',
  'body': 'Hi there!',
  'createdAt': '2026-03-05T04:30:00.000Z',
};

void main() {
  test(
    'getInbox uses /email/inbox with assignment pagination params',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://test'));
      final adapter = DioAdapter(dio: dio);
      adapter.onGet(
        '/email/inbox',
        (server) => server.reply(200, <String, dynamic>{
          'total': 1,
          'data': <dynamic>[_emailJson(1)],
        }),
        queryParameters: <String, dynamic>{'page': 2, 'limit': 10},
      );

      final page = await MailRepository(dio).getInbox(page: 2, limit: 10);

      expect(page.total, 1);
      expect(page.items.single.id, 1);
    },
  );

  test('sendEmail posts recipientEmails to /email', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    final adapter = DioAdapter(dio: dio);
    adapter.onPost(
      '/email',
      (server) => server.reply(201, _emailJson(7)),
      data: <String, dynamic>{
        'recipientEmails': ['user2@mock.com'],
        'subject': 'Hello',
        'body': 'Hi there!',
      },
    );

    final sent = await MailRepository(dio).sendEmail(
      recipientEmails: ['user2@mock.com'],
      subject: 'Hello',
      body: 'Hi there!',
    );

    expect(sent.id, 7);
  });
}
