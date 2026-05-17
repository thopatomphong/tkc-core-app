import 'package:core_app/models/email_message.dart';
import 'package:core_app/models/paginated.dart';
import 'package:dio/dio.dart';

class MailRepository {
  const MailRepository(this._dio);

  final Dio _dio;

  Future<Paginated<EmailMessage>> getInbox({int page = 1, int limit = 10}) {
    return _getPage('/email/inbox', page: page, limit: limit);
  }

  Future<Paginated<EmailMessage>> getSent({int page = 1, int limit = 10}) {
    return _getPage('/email/sent', page: page, limit: limit);
  }

  Future<EmailMessage> getEmail(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('/email/$id');
    return EmailMessage.fromJson(res.data!);
  }

  Future<EmailMessage> sendEmail({
    required List<String> recipientEmails,
    required String subject,
    required String body,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/email',
      data: <String, dynamic>{
        'recipientEmails': recipientEmails,
        'subject': subject,
        'body': body,
      },
    );
    return EmailMessage.fromJson(res.data!);
  }

  Future<Paginated<EmailMessage>> _getPage(
    String path, {
    required int page,
    required int limit,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: <String, dynamic>{'page': page, 'limit': limit},
    );
    return Paginated<EmailMessage>.fromJson(res.data!, EmailMessage.fromJson);
  }
}
