import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';

class GetEmailDetailUseCase {
  const GetEmailDetailUseCase(this._repository);
  final MailRepository _repository;

  Future<EmailMessage> call(int id) => _repository.getEmail(id);
}
