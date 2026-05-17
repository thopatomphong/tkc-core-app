import 'package:core_app/core/providers.dart';
import 'package:core_app/features/mail/mail_repository.dart';
import 'package:core_app/models/email_message.dart';
import 'package:core_app/models/paginated.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mail_providers.g.dart';

@riverpod
MailRepository mailRepository(MailRepositoryRef ref) {
  return MailRepository(ref.watch(dioProvider));
}

@riverpod
Future<Paginated<EmailMessage>> inbox(InboxRef ref, {int page = 1}) {
  return ref.watch(mailRepositoryProvider).getInbox(page: page);
}

@riverpod
Future<Paginated<EmailMessage>> sentMail(SentMailRef ref, {int page = 1}) {
  return ref.watch(mailRepositoryProvider).getSent(page: page);
}

@riverpod
Future<EmailMessage> emailDetail(EmailDetailRef ref, int id) {
  return ref.watch(mailRepositoryProvider).getEmail(id);
}
