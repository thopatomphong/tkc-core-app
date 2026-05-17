import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/features/mail/domain/use_cases/get_inbox_use_case.dart';
import 'package:core_app/models/paginated.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMailRepository extends Mock implements MailRepository {}

void main() {
  late MockMailRepository repo;
  late GetInboxUseCase useCase;

  final fakeEmail = EmailMessage(
    id: 1,
    senderId: 2,
    senderUsername: 'alice',
    recipientId: 3,
    recipientUsername: 'bob',
    subject: 'Hello',
    body: 'World',
    createdAt: DateTime(2026, 3, 5),
  );

  setUp(() {
    repo = MockMailRepository();
    useCase = GetInboxUseCase(repo);
  });

  test('delegates to repository with page and limit', () async {
    when(() => repo.getInbox(page: 1, limit: 10))
        .thenAnswer((_) async => Paginated(total: 1, items: [fakeEmail]));

    final result = await useCase(page: 1);

    expect(result.total, 1);
    expect(result.items.first.senderUsername, 'alice');
    verify(() => repo.getInbox(page: 1, limit: 10)).called(1);
  });
}
