import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/features/mail/domain/use_cases/get_email_detail_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMailRepository extends Mock implements MailRepository {}

void main() {
  late MockMailRepository repo;
  late GetEmailDetailUseCase useCase;

  final fakeEmail = EmailMessage(
    id: 42,
    senderId: 1,
    senderUsername: 'system',
    recipientId: 2,
    recipientUsername: 'user1',
    subject: 'Welcome',
    body: 'Hello!',
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    repo = MockMailRepository();
    useCase = GetEmailDetailUseCase(repo);
  });

  test('fetches email by id from repository', () async {
    when(() => repo.getEmail(42)).thenAnswer((_) async => fakeEmail);

    final result = await useCase(42);

    expect(result.id, 42);
    expect(result.subject, 'Welcome');
    verify(() => repo.getEmail(42)).called(1);
  });
}
