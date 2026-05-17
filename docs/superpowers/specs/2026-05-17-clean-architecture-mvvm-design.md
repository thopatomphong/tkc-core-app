# Clean Architecture + MVVM — Design Spec

**Date:** 2026-05-17  
**Scope:** `mail` feature as reference implementation  
**Pattern:** Clean Architecture (Option B — Domain + Data, no datasource layer) + MVVM via Riverpod

---

## Goals

- Establish a testable, modular architecture baseline before the codebase grows further
- Define clear layer boundaries: domain / data / presentation
- Make business logic independently unit-testable without Flutter or Dio
- Provide a reference implementation in `features/mail/` that all future features follow

---

## Folder Structure

The `mail` feature is restructured into three explicit sublayers. All other features and global code remain unchanged.

```
lib/features/mail/
│
├── domain/
│   ├── entities/
│   │   └── email_message.dart            # pure Dart, no JSON annotations
│   ├── repositories/
│   │   └── mail_repository.dart          # abstract class MailRepository
│   └── use_cases/
│       ├── get_inbox_use_case.dart
│       ├── get_sent_use_case.dart
│       ├── get_email_detail_use_case.dart
│       └── send_email_use_case.dart
│
├── data/
│   ├── dtos/
│   │   └── email_message_dto.dart        # Freezed + JSON + toEntity() mapper
│   └── mail_repository_impl.dart         # implements MailRepository, uses Dio
│
└── presentation/
    ├── providers/
    │   ├── mail_providers.dart            # functional providers (inbox, sent, detail)
    │   └── compose_notifier.dart          # AsyncNotifier for send flow
    ├── screens/
    │   ├── inbox_screen.dart
    │   ├── email_detail_screen.dart
    │   └── compose_screen.dart
    └── widgets/
        ├── email_tile.dart
        └── mail_list_view.dart
```

`lib/models/email_message.dart` (and generated files) is replaced by the DTO in `data/dtos/` and the entity in `domain/entities/`. Other global models in `lib/models/` are not touched.

---

## Domain Layer

### Entity — `EmailMessage`

Pure Dart class. No Freezed, no JSON. Only carries fields the app cares about.

```dart
class EmailMessage {
  const EmailMessage({
    required this.id,
    required this.subject,
    required this.senderEmail,
    required this.recipientEmail,
    required this.body,
    required this.sentAt,
    required this.isRead,
  });

  final int id;
  final String subject;
  final String senderEmail;
  final String recipientEmail;
  final String body;
  final DateTime sentAt;
  final bool isRead;
}
```

### Abstract Repository — `MailRepository`

```dart
abstract class MailRepository {
  Future<Paginated<EmailMessage>> getInbox({int page = 1, int limit = 10});
  Future<Paginated<EmailMessage>> getSent({int page = 1, int limit = 10});
  Future<EmailMessage> getEmail(int id);
  Future<EmailMessage> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  });
}
```

Presentation and use cases depend only on this interface. The concrete implementation is never imported above the data layer.

### Use Cases

Each use case is a single-method class injected with `MailRepository`. Business validation belongs here (e.g., `SendEmailUseCase` rejects empty subject/recipient before calling the repo).

```dart
class GetInboxUseCase {
  const GetInboxUseCase(this._repository);
  final MailRepository _repository;

  Future<Paginated<EmailMessage>> call({int page = 1}) =>
      _repository.getInbox(page: page);
}
```

`GetSentUseCase`, `GetEmailDetailUseCase`, and `SendEmailUseCase` follow the same shape.

---

## Data Layer

### DTO — `EmailMessageDto`

Freezed + JSON lives in `data/dtos/`. An extension adds the `toEntity()` mapper keeping mapping logic co-located with the DTO.

```dart
@freezed
class EmailMessageDto with _$EmailMessageDto {
  const factory EmailMessageDto({
    required int id,
    required String subject,
    required String senderEmail,
    required String recipientEmail,
    required String body,
    required DateTime sentAt,
    required bool isRead,
  }) = _EmailMessageDto;

  factory EmailMessageDto.fromJson(Map<String, dynamic> json) =>
      _$EmailMessageDtoFromJson(json);
}

extension EmailMessageDtoMapper on EmailMessageDto {
  EmailMessage toEntity() => EmailMessage(
        id: id,
        subject: subject,
        senderEmail: senderEmail,
        recipientEmail: recipientEmail,
        body: body,
        sentAt: sentAt,
        isRead: isRead,
      );
}
```

### Repository Impl — `MailRepositoryImpl`

Implements `MailRepository`. Handles Dio calls, parses DTOs, and maps to entities. No business logic.

```dart
class MailRepositoryImpl implements MailRepository {
  const MailRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<Paginated<EmailMessage>> getInbox({int page = 1, int limit = 10}) async {
    final res = await _dio.get('/email/inbox',
        queryParameters: {'page': page, 'limit': limit});
    final dto = Paginated<EmailMessageDto>.fromJson(
        res.data, EmailMessageDto.fromJson);
    return dto.map((d) => d.toEntity());
  }
  // getSent, getEmail, sendEmail follow same pattern
}
```

`Paginated<T>` gains a `.map<R>(R Function(T) mapper)` helper method to support this one-liner conversion.

---

## Presentation Layer

### Dependency Wiring

All wiring lives in `mail_providers.dart`. Screens never instantiate repositories or use cases.

```dart
@riverpod
MailRepository mailRepository(Ref ref) =>
    MailRepositoryImpl(ref.watch(dioProvider));

@riverpod
GetInboxUseCase getInboxUseCase(Ref ref) =>
    GetInboxUseCase(ref.watch(mailRepositoryProvider));

// getSentUseCase, getEmailDetailUseCase, sendEmailUseCase follow same pattern

@riverpod
Future<Paginated<EmailMessage>> inbox(Ref ref, {int page = 1}) =>
    ref.watch(getInboxUseCaseProvider).call(page: page);

@riverpod
Future<Paginated<EmailMessage>> sentMail(Ref ref, {int page = 1}) =>
    ref.watch(getSentUseCaseProvider).call(page: page);

@riverpod
Future<EmailMessage> emailDetail(Ref ref, int id) =>
    ref.watch(getEmailDetailUseCaseProvider).call(id);
```

Functional providers for reads; `AsyncNotifier` only for the send mutation.

### Compose Notifier

```dart
@riverpod
class ComposeNotifier extends _$ComposeNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> send({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(sendEmailUseCaseProvider).call(
              recipientEmail: recipientEmail,
              subject: subject,
              body: body,
            ));
  }
}
```

### Screens

Screens remain `ConsumerWidget` / `ConsumerStatefulWidget`. They watch providers and render state only. Tab controller and pagination cursor stay as local widget state — they are purely UI concerns.

---

## Data Flow

```
Screen
  └─ watches functional provider / ComposeNotifier
       └─ calls UseCase
            └─ calls abstract MailRepository
                 └─ MailRepositoryImpl (Dio → DTO → Entity)
```

The dependency rule is enforced by import direction:
- `domain/` imports nothing from `data/` or `presentation/`
- `data/` imports `domain/` (implements the interface)
- `presentation/` imports `domain/` (use cases + entities) and `data/` (for wiring in providers only)

---

## Testing Strategy

Each layer is tested in isolation. The mock boundary is always `MailRepository`.

### Domain — pure unit tests

```dart
class MockMailRepository extends Mock implements MailRepository {}

test('GetInboxUseCase returns first page', () async {
  final repo = MockMailRepository();
  when(() => repo.getInbox(page: 1, limit: 10))
      .thenAnswer((_) async => fakePaginated);

  final result = await GetInboxUseCase(repo).call(page: 1);
  expect(result.items, hasLength(2));
});
```

No Dio, no Riverpod, no widgets.

### Data — integration tests with `http_mock_adapter`

```dart
test('getInbox maps DTO fields to entity correctly', () async {
  dioAdapter.onGet('/email/inbox').reply(200, fakeInboxJson);
  final result = await MailRepositoryImpl(dio).getInbox();
  expect(result.items.first.senderEmail, 'alice@example.com');
});
```

Verifies JSON parsing and DTO→entity mapping.

### Presentation — widget tests with provider overrides

```dart
testWidgets('InboxScreen shows email subjects', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        mailRepositoryProvider.overrideWithValue(MockMailRepository()),
      ],
      child: const InboxScreen(),
    ),
  );
  expect(find.text('Meeting Notes'), findsOneWidget);
});
```

---

## Migration Notes

- `lib/models/email_message.dart` and its generated files (`*.freezed.dart`, `*.g.dart`) are deleted and replaced by the DTO + entity split above.
- `lib/features/mail/mail_repository.dart` (current concrete class) is replaced by `data/mail_repository_impl.dart`.
- `lib/features/mail/mail_providers.dart` is replaced by `presentation/providers/mail_providers.dart` with updated wiring.
- All existing screens and widgets are moved into `presentation/screens/` and `presentation/widgets/` with no functional changes.
- `lib/models/paginated.dart` gains a `.map<R>()` helper; it is not moved.

---

## Out of Scope

- Migrating `auth`, `profile`, or `launcher` features — this is the reference implementation only.
- Local caching or offline support.
- Pagination cursor management beyond the existing page-number approach.
