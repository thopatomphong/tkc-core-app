import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/models/paginated.dart';

class GetInboxUseCase {
  const GetInboxUseCase(this._repository);
  final MailRepository _repository;

  Future<Paginated<EmailMessage>> call({int page = 1, int limit = 10}) =>
      _repository.getInbox(page: page, limit: limit);
}
