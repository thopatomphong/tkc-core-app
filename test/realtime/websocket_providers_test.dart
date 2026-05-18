import 'package:core_app/core/providers.dart';
import 'package:core_app/core/storage/token_storage.dart';
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/features/mail/presentation/providers/mail_providers.dart';
import 'package:core_app/models/auth_tokens.dart';
import 'package:core_app/models/paginated.dart';
import 'package:core_app/realtime/websocket_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('new email events records the received email id', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(newEmailEventsProvider), isNull);

    container.read(newEmailEventsProvider.notifier).received(99);

    expect(container.read(newEmailEventsProvider), 99);
  });

  test(
    'websocket new email callback invalidates paginated inbox and emits event',
    () async {
      final tokenStorage = TokenStorage.forTesting({});
      await tokenStorage.saveTokens(
        AuthTokens(
          accessToken: 'access-token',
          accessTokenExpiresAt: DateTime(2026, 1, 1),
          refreshToken: 'refresh-token',
          refreshTokenExpiresAt: DateTime(2026, 1, 2),
        ),
      );
      final repository = _CountingMailRepository();
      final container = ProviderContainer(
        overrides: [
          tokenStorageProvider.overrideWithValue(tokenStorage),
          mailRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final inboxSubscription = container.listen(
        inboxProvider(page: 2),
        (previous, next) {},
        fireImmediately: true,
      );
      addTearDown(inboxSubscription.close);

      await container.read(inboxProvider(page: 2).future);
      expect(repository.inboxCallsByPage[2], 1);
      expect(container.read(newEmailEventsProvider), isNull);

      final service = container.read(webSocketServiceProvider);
      service.onNewEmail?.call(123);
      await container.pump();

      await container.read(inboxProvider(page: 2).future);
      expect(repository.inboxCallsByPage[2], 2);
      expect(container.read(newEmailEventsProvider), 123);
    },
  );
}

class _CountingMailRepository implements MailRepository {
  final inboxCallsByPage = <int, int>{};

  @override
  Future<Paginated<EmailMessage>> getInbox({
    int page = 1,
    int limit = 10,
  }) async {
    inboxCallsByPage.update(page, (count) => count + 1, ifAbsent: () => 1);
    return Paginated(
      total: 20,
      items: [
        EmailMessage(
          id: page,
          senderId: 1,
          senderUsername: 'sender',
          recipientId: 2,
          recipientUsername: 'recipient',
          subject: 'Page $page',
          body: 'Body $page',
          createdAt: DateTime(2026, 1, page),
        ),
      ],
    );
  }

  @override
  Future<EmailMessage> getEmail(int id) => throw UnimplementedError();

  @override
  Future<Paginated<EmailMessage>> getSent({int page = 1, int limit = 10}) =>
      throw UnimplementedError();

  @override
  Future<EmailMessage> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) => throw UnimplementedError();
}
