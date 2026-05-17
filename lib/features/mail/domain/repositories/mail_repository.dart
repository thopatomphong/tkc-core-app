import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/models/paginated.dart';

abstract class MailRepository {
  Future<Paginated<EmailMessage>> getInbox({int page = 1, int limit = 10});
  Future<Paginated<EmailMessage>> getSent({int page = 1, int limit = 10});
  Future<EmailMessage> getEmail(int id);
  Future<EmailMessage> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  });
}
