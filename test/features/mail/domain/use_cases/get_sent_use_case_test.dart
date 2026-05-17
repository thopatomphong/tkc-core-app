import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/features/mail/domain/use_cases/get_sent_use_case.dart';
import 'package:core_app/models/paginated.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMailRepository extends Mock implements MailRepository {}

void main() {
  late MockMailRepository repo;
  late GetSentUseCase useCase;

  final fakeEmail = EmailMessage(
    id: 2,
    senderId: 3,
    senderUsername: 'bob',
    recipientId: 2,
    recipientUsername: 'alice',
    subject: 'Re: Hello',
    body: 'Reply',
    createdAt: DateTime(2026, 3, 6),
  );

  setUp(() {
    repo = MockMailRepository();
    useCase = GetSentUseCase(repo);
  });

  test('delegates to repository with page and limit', () async {
    when(() => repo.getSent(page: 2, limit: 10))
        .thenAnswer((_) async => Paginated(total: 1, items: [fakeEmail]));

    final result = await useCase(page: 2);

    expect(result.items.first.subject, 'Re: Hello');
    verify(() => repo.getSent(page: 2, limit: 10)).called(1);
  });
}
