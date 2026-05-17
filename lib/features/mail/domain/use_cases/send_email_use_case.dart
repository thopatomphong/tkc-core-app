import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';

class SendEmailUseCase {
  const SendEmailUseCase(this._repository);
  final MailRepository _repository;

  Future<EmailMessage> call({
    required String recipientEmail,
    required String subject,
    required String body,
  }) {
    if (recipientEmail.trim().isEmpty) {
      throw ArgumentError('Recipient email cannot be empty');
    }
    if (subject.trim().isEmpty) {
      throw ArgumentError('Subject cannot be empty');
    }
    return _repository.sendEmail(
      recipientEmail: recipientEmail,
      subject: subject,
      body: body,
    );
  }
}
