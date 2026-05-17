import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/features/mail/domain/use_cases/send_email_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMailRepository extends Mock implements MailRepository {}

void main() {
  late MockMailRepository repo;
  late SendEmailUseCase useCase;

  final fakeSentEmail = EmailMessage(
    id: 10,
    senderId: 1,
    senderUsername: 'me',
    recipientId: 2,
    recipientUsername: 'you',
    subject: 'Hi',
    body: 'Body',
    createdAt: DateTime(2026, 5, 1),
  );

  setUp(() {
    repo = MockMailRepository();
    useCase = SendEmailUseCase(repo);
  });

  test('delegates to repository when inputs are valid', () async {
    when(() => repo.sendEmail(
          recipientEmail: 'you@example.com',
          subject: 'Hi',
          body: 'Body',
        )).thenAnswer((_) async => fakeSentEmail);

    final result = await useCase(
      recipientEmail: 'you@example.com',
      subject: 'Hi',
      body: 'Body',
    );

    expect(result.id, 10);
    verify(() => repo.sendEmail(
          recipientEmail: 'you@example.com',
          subject: 'Hi',
          body: 'Body',
        )).called(1);
  });

  test('throws ArgumentError when recipientEmail is blank', () async {
    expect(
      () => useCase(recipientEmail: '  ', subject: 'Hi', body: 'Body'),
      throwsA(isA<ArgumentError>()),
    );
    verifyNever(() => repo.sendEmail(
          recipientEmail: any(named: 'recipientEmail'),
          subject: any(named: 'subject'),
          body: any(named: 'body'),
        ));
  });

  test('throws ArgumentError when subject is blank', () async {
    expect(
      () => useCase(recipientEmail: 'you@example.com', subject: '', body: 'Body'),
      throwsA(isA<ArgumentError>()),
    );
  });
}
