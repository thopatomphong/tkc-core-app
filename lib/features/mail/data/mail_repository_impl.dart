import 'package:core_app/features/mail/data/dtos/email_message_dto.dart';
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/models/paginated.dart';
import 'package:dio/dio.dart';

class MailRepositoryImpl implements MailRepository {
  const MailRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<Paginated<EmailMessage>> getInbox({int page = 1, int limit = 10}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/email/inbox',
      queryParameters: <String, dynamic>{'page': page, 'limit': limit},
    );
    return Paginated<EmailMessageDto>.fromJson(res.data!, EmailMessageDto.fromJson)
        .map((dto) => dto.toEntity());
  }

  @override
  Future<Paginated<EmailMessage>> getSent({int page = 1, int limit = 10}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/email/sent',
      queryParameters: <String, dynamic>{'page': page, 'limit': limit},
    );
    return Paginated<EmailMessageDto>.fromJson(res.data!, EmailMessageDto.fromJson)
        .map((dto) => dto.toEntity());
  }

  @override
  Future<EmailMessage> getEmail(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('/email/$id');
    return EmailMessageDto.fromJson(res.data!).toEntity();
  }

  @override
  Future<EmailMessage> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/email',
      data: <String, dynamic>{
        'recipientEmail': recipientEmail,
        'subject': subject,
        'body': body,
      },
    );
    return EmailMessageDto.fromJson(res.data!).toEntity();
  }
}
