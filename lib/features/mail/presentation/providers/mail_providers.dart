import 'package:core_app/core/providers.dart';
import 'package:core_app/features/mail/data/mail_repository_impl.dart';
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/features/mail/domain/use_cases/get_email_detail_use_case.dart';
import 'package:core_app/features/mail/domain/use_cases/get_inbox_use_case.dart';
import 'package:core_app/features/mail/domain/use_cases/get_sent_use_case.dart';
import 'package:core_app/features/mail/domain/use_cases/send_email_use_case.dart';
import 'package:core_app/models/paginated.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mail_providers.g.dart';

@riverpod
MailRepository mailRepository(MailRepositoryRef ref) =>
    MailRepositoryImpl(ref.watch(dioProvider));

@riverpod
GetInboxUseCase getInboxUseCase(GetInboxUseCaseRef ref) =>
    GetInboxUseCase(ref.watch(mailRepositoryProvider));

@riverpod
GetSentUseCase getSentUseCase(GetSentUseCaseRef ref) =>
    GetSentUseCase(ref.watch(mailRepositoryProvider));

@riverpod
GetEmailDetailUseCase getEmailDetailUseCase(GetEmailDetailUseCaseRef ref) =>
    GetEmailDetailUseCase(ref.watch(mailRepositoryProvider));

@riverpod
SendEmailUseCase sendEmailUseCase(SendEmailUseCaseRef ref) =>
    SendEmailUseCase(ref.watch(mailRepositoryProvider));

@riverpod
Future<Paginated<EmailMessage>> inbox(InboxRef ref, {int page = 1}) =>
    ref.watch(getInboxUseCaseProvider).call(page: page);

@riverpod
Future<Paginated<EmailMessage>> sentMail(SentMailRef ref, {int page = 1}) =>
    ref.watch(getSentUseCaseProvider).call(page: page);

@riverpod
Future<EmailMessage> emailDetail(EmailDetailRef ref, int id) =>
    ref.watch(getEmailDetailUseCaseProvider).call(id);
