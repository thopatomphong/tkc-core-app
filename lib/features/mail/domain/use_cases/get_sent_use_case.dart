import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/models/paginated.dart';

class GetSentUseCase {
  const GetSentUseCase(this._repository);
  final MailRepository _repository;

  Future<Paginated<EmailMessage>> call({int page = 1, int limit = 10}) =>
      _repository.getSent(page: page, limit: limit);
}
