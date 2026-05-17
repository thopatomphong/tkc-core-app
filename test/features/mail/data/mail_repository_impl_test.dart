import 'package:core_app/features/mail/data/mail_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late MailRepositoryImpl repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    adapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    repo = MailRepositoryImpl(dio);
  });

  const inboxJson = <String, dynamic>{
    'total': 1,
    'data': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 1,
        'senderId': 2,
        'senderUsername': 'alice',
        'recipientId': 3,
        'recipientUsername': 'bob',
        'subject': 'Hello',
        'body': 'World',
        'createdAt': '2026-03-05T10:00:00.000Z',
      }
    ],
  };

  test('getInbox maps DTO fields to entity correctly', () async {
    adapter.onGet(
      '/email/inbox',
      (server) => server.reply(200, inboxJson),
      queryParameters: <String, dynamic>{'page': 1, 'limit': 10},
    );

    final result = await repo.getInbox();

    expect(result.total, 1);
    expect(result.items.first.senderUsername, 'alice');
    expect(result.items.first.id, 1);
    expect(result.items.first.createdAt.year, 2026);
  });

  test('getSent maps DTO fields to entity correctly', () async {
    adapter.onGet(
      '/email/sent',
      (server) => server.reply(200, inboxJson),
      queryParameters: <String, dynamic>{'page': 1, 'limit': 10},
    );

    final result = await repo.getSent();

    expect(result.items.first.subject, 'Hello');
  });

  test('getEmail maps single DTO to entity', () async {
    final singleItem =
        (inboxJson['data']! as List<Map<String, dynamic>>).first;

    adapter.onGet(
      '/email/1',
      (server) => server.reply(200, singleItem),
    );

    final result = await repo.getEmail(1);

    expect(result.id, 1);
    expect(result.body, 'World');
  });

  test('sendEmail posts and maps response to entity', () async {
    final singleItem =
        (inboxJson['data']! as List<Map<String, dynamic>>).first;

    adapter.onPost(
      '/email',
      (server) => server.reply(200, singleItem),
    );

    final result = await repo.sendEmail(
      recipientEmail: 'bob@example.com',
      subject: 'Hello',
      body: 'World',
    );

    expect(result.subject, 'Hello');
  });
}
