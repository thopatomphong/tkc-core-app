# Clean Architecture + MVVM (mail feature) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure `features/mail` into Clean Architecture (domain / data / presentation) as the reference implementation for all future features.

**Architecture:** Domain layer holds a pure `EmailMessage` entity, an abstract `MailRepository` interface, and four use case classes. Data layer holds `EmailMessageDto` (Freezed + JSON) and `MailRepositoryImpl`. Presentation layer wires everything via Riverpod functional providers (reads) and a `ComposeNotifier` (write).

**Tech Stack:** Flutter, Riverpod (hooks_riverpod + riverpod_annotation + riverpod_generator), Freezed, Dio, mocktail, http_mock_adapter

---

## File Map

**Create:**
- `lib/features/mail/domain/entities/email_message.dart`
- `lib/features/mail/domain/repositories/mail_repository.dart`
- `lib/features/mail/domain/use_cases/get_inbox_use_case.dart`
- `lib/features/mail/domain/use_cases/get_sent_use_case.dart`
- `lib/features/mail/domain/use_cases/get_email_detail_use_case.dart`
- `lib/features/mail/domain/use_cases/send_email_use_case.dart`
- `lib/features/mail/data/dtos/email_message_dto.dart`
- `lib/features/mail/data/mail_repository_impl.dart`
- `lib/features/mail/presentation/providers/mail_providers.dart`
- `lib/features/mail/presentation/providers/compose_notifier.dart`
- `lib/features/mail/presentation/screens/inbox_screen.dart`
- `lib/features/mail/presentation/screens/email_detail_screen.dart`
- `lib/features/mail/presentation/screens/compose_screen.dart`
- `lib/features/mail/presentation/widgets/email_tile.dart`
- `lib/features/mail/presentation/widgets/mail_list_view.dart`
- `test/features/mail/domain/use_cases/get_inbox_use_case_test.dart`
- `test/features/mail/domain/use_cases/get_sent_use_case_test.dart`
- `test/features/mail/domain/use_cases/get_email_detail_use_case_test.dart`
- `test/features/mail/domain/use_cases/send_email_use_case_test.dart`
- `test/features/mail/data/mail_repository_impl_test.dart`

**Modify:**
- `lib/models/paginated.dart` — add `.map<R>()` helper method
- `lib/core/router/app_router.dart` — update imports to `presentation/screens/`
- `test/models/email_message_test.dart` — update to test `EmailMessageDto`

**Delete (Task 14):**
- `lib/features/mail/mail_repository.dart`
- `lib/features/mail/mail_providers.dart`
- `lib/features/mail/mail_providers.g.dart`
- `lib/models/email_message.dart`
- `lib/models/email_message.freezed.dart`
- `lib/models/email_message.g.dart`
- `lib/features/mail/inbox_screen.dart`
- `lib/features/mail/email_detail_screen.dart`
- `lib/features/mail/compose_screen.dart`
- `lib/features/mail/widgets/email_tile.dart`
- `lib/features/mail/widgets/mail_list_view.dart`

---

## Task 1: Add `Paginated.map<R>()` helper

`MailRepositoryImpl` needs to convert `Paginated<EmailMessageDto>` → `Paginated<EmailMessage>` in one step.

**Files:**
- Modify: `lib/models/paginated.dart`

- [ ] **Step 1: Write the failing test**

Create `test/models/paginated_test.dart`:

```dart
import 'package:core_app/models/paginated.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('map converts item type preserving total and order', () {
    final page = Paginated<int>(total: 5, items: [1, 2, 3]);
    final mapped = page.map((n) => n * 10);
    expect(mapped.total, 5);
    expect(mapped.items, [10, 20, 30]);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```
flutter test test/models/paginated_test.dart
```

Expected: FAIL — `The method 'map' isn't defined`

- [ ] **Step 3: Add `.map<R>()` to `Paginated<T>`**

In `lib/models/paginated.dart`, add this method inside the class body after the `fromJson` factory:

```dart
Paginated<R> map<R>(R Function(T) mapper) {
  return Paginated<R>(
    total: total,
    items: items.map(mapper).toList(),
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

```
flutter test test/models/paginated_test.dart
```

Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/models/paginated.dart test/models/paginated_test.dart
git commit -m "feat: add Paginated.map<R>() for DTO-to-entity conversion"
```

---

## Task 2: Create `EmailMessage` domain entity

Pure Dart class — no Freezed, no JSON, no framework imports.

**Files:**
- Create: `lib/features/mail/domain/entities/email_message.dart`

- [ ] **Step 1: Create the entity**

```dart
class EmailMessage {
  const EmailMessage({
    required this.id,
    required this.senderId,
    required this.senderUsername,
    required this.recipientId,
    required this.recipientUsername,
    required this.subject,
    required this.body,
    required this.createdAt,
  });

  final int id;
  final int senderId;
  final String senderUsername;
  final int recipientId;
  final String recipientUsername;
  final String subject;
  final String body;
  final DateTime createdAt;
}
```

- [ ] **Step 2: Verify it compiles**

```
flutter analyze lib/features/mail/domain/entities/email_message.dart
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/features/mail/domain/entities/email_message.dart
git commit -m "feat: add EmailMessage domain entity"
```

---

## Task 3: Create abstract `MailRepository` interface

**Files:**
- Create: `lib/features/mail/domain/repositories/mail_repository.dart`

- [ ] **Step 1: Create the interface**

```dart
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/models/paginated.dart';

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

- [ ] **Step 2: Verify it compiles**

```
flutter analyze lib/features/mail/domain/repositories/mail_repository.dart
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/features/mail/domain/repositories/mail_repository.dart
git commit -m "feat: add abstract MailRepository interface"
```

---

## Task 4: Create and test `GetInboxUseCase`

**Files:**
- Create: `lib/features/mail/domain/use_cases/get_inbox_use_case.dart`
- Create: `test/features/mail/domain/use_cases/get_inbox_use_case_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

```
flutter test test/features/mail/domain/use_cases/get_inbox_use_case_test.dart
```

Expected: FAIL — `Target of URI doesn't exist: get_inbox_use_case.dart`

- [ ] **Step 3: Create the use case**

```dart
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/models/paginated.dart';

class GetInboxUseCase {
  const GetInboxUseCase(this._repository);
  final MailRepository _repository;

  Future<Paginated<EmailMessage>> call({int page = 1, int limit = 10}) =>
      _repository.getInbox(page: page, limit: limit);
}
```

- [ ] **Step 4: Run test to verify it passes**

```
flutter test test/features/mail/domain/use_cases/get_inbox_use_case_test.dart
```

Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/mail/domain/use_cases/get_inbox_use_case.dart \
        test/features/mail/domain/use_cases/get_inbox_use_case_test.dart
git commit -m "feat: add GetInboxUseCase with test"
```

---

## Task 5: Create and test `GetSentUseCase`

**Files:**
- Create: `lib/features/mail/domain/use_cases/get_sent_use_case.dart`
- Create: `test/features/mail/domain/use_cases/get_sent_use_case_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

```
flutter test test/features/mail/domain/use_cases/get_sent_use_case_test.dart
```

Expected: FAIL — `Target of URI doesn't exist: get_sent_use_case.dart`

- [ ] **Step 3: Create the use case**

```dart
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/models/paginated.dart';

class GetSentUseCase {
  const GetSentUseCase(this._repository);
  final MailRepository _repository;

  Future<Paginated<EmailMessage>> call({int page = 1, int limit = 10}) =>
      _repository.getSent(page: page, limit: limit);
}
```

- [ ] **Step 4: Run test to verify it passes**

```
flutter test test/features/mail/domain/use_cases/get_sent_use_case_test.dart
```

Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/mail/domain/use_cases/get_sent_use_case.dart \
        test/features/mail/domain/use_cases/get_sent_use_case_test.dart
git commit -m "feat: add GetSentUseCase with test"
```

---

## Task 6: Create and test `GetEmailDetailUseCase`

**Files:**
- Create: `lib/features/mail/domain/use_cases/get_email_detail_use_case.dart`
- Create: `test/features/mail/domain/use_cases/get_email_detail_use_case_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

```
flutter test test/features/mail/domain/use_cases/get_email_detail_use_case_test.dart
```

Expected: FAIL — `Target of URI doesn't exist: get_email_detail_use_case.dart`

- [ ] **Step 3: Create the use case**

```dart
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';

class GetEmailDetailUseCase {
  const GetEmailDetailUseCase(this._repository);
  final MailRepository _repository;

  Future<EmailMessage> call(int id) => _repository.getEmail(id);
}
```

- [ ] **Step 4: Run test to verify it passes**

```
flutter test test/features/mail/domain/use_cases/get_email_detail_use_case_test.dart
```

Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/mail/domain/use_cases/get_email_detail_use_case.dart \
        test/features/mail/domain/use_cases/get_email_detail_use_case_test.dart
git commit -m "feat: add GetEmailDetailUseCase with test"
```

---

## Task 7: Create and test `SendEmailUseCase`

This use case adds validation before calling the repository.

**Files:**
- Create: `lib/features/mail/domain/use_cases/send_email_use_case.dart`
- Create: `test/features/mail/domain/use_cases/send_email_use_case_test.dart`

- [ ] **Step 1: Write the failing tests**

```dart
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
```

- [ ] **Step 2: Run tests to verify they fail**

```
flutter test test/features/mail/domain/use_cases/send_email_use_case_test.dart
```

Expected: FAIL — `Target of URI doesn't exist: send_email_use_case.dart`

- [ ] **Step 3: Create the use case**

```dart
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';

class SendEmailUseCase {
  const SendEmailUseCase(this._repository);
  final MailRepository _repository;

  Future<EmailMessage> call({
    required String recipientEmail,
    required String subject,
    required String body,
  }) {
    if (recipientEmail.trim().isEmpty) {
      throw ArgumentError('Recipient email cannot be empty');
    }
    if (subject.trim().isEmpty) {
      throw ArgumentError('Subject cannot be empty');
    }
    return _repository.sendEmail(
      recipientEmail: recipientEmail,
      subject: subject,
      body: body,
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

```
flutter test test/features/mail/domain/use_cases/send_email_use_case_test.dart
```

Expected: 3 tests PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/mail/domain/use_cases/send_email_use_case.dart \
        test/features/mail/domain/use_cases/send_email_use_case_test.dart
git commit -m "feat: add SendEmailUseCase with validation and tests"
```

---

## Task 8: Create `EmailMessageDto` and run code generation

**Files:**
- Create: `lib/features/mail/data/dtos/email_message_dto.dart`

- [ ] **Step 1: Create the DTO**

```dart
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_message_dto.freezed.dart';
part 'email_message_dto.g.dart';

@freezed
class EmailMessageDto with _$EmailMessageDto {
  const factory EmailMessageDto({
    required int id,
    required int senderId,
    required String senderUsername,
    required int recipientId,
    required String recipientUsername,
    required String subject,
    required String body,
    required DateTime createdAt,
  }) = _EmailMessageDto;

  factory EmailMessageDto.fromJson(Map<String, dynamic> json) =>
      _$EmailMessageDtoFromJson(json);
}

extension EmailMessageDtoMapper on EmailMessageDto {
  EmailMessage toEntity() => EmailMessage(
        id: id,
        senderId: senderId,
        senderUsername: senderUsername,
        recipientId: recipientId,
        recipientUsername: recipientUsername,
        subject: subject,
        body: body,
        createdAt: createdAt,
      );
}
```

- [ ] **Step 2: Run code generation**

```
dart run build_runner build --delete-conflicting-outputs
```

Expected: generates `email_message_dto.freezed.dart` and `email_message_dto.g.dart`

- [ ] **Step 3: Verify it compiles**

```
flutter analyze lib/features/mail/data/dtos/email_message_dto.dart
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/features/mail/data/dtos/
git commit -m "feat: add EmailMessageDto with toEntity() mapper"
```

---

## Task 9: Create and test `MailRepositoryImpl`

**Files:**
- Create: `lib/features/mail/data/mail_repository_impl.dart`
- Create: `test/features/mail/data/mail_repository_impl_test.dart`

- [ ] **Step 1: Write the failing tests**

```dart
import 'package:core_app/features/mail/data/mail_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late MailRepositoryImpl repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    adapter = DioAdapter(dio: dio);
    repo = MailRepositoryImpl(dio);
  });

  final inboxJson = {
    'total': 1,
    'data': [
      {
        'id': 1,
        'senderId': 2,
        'senderUsername': 'alice',
        'recipientId': 3,
        'recipientUsername': 'bob',
        'subject': 'Hello',
        'body': 'World',
        'createdAt': '2026-03-05T10:00:00.000Z',
      }
    ],
  };

  test('getInbox maps DTO fields to entity correctly', () async {
    adapter.onGet(
      '/email/inbox',
      queryParameters: {'page': 1, 'limit': 10},
    ).reply(200, inboxJson);

    final result = await repo.getInbox();

    expect(result.total, 1);
    expect(result.items.first.senderUsername, 'alice');
    expect(result.items.first.id, 1);
    expect(result.items.first.createdAt.year, 2026);
  });

  test('getSent maps DTO fields to entity correctly', () async {
    adapter.onGet(
      '/email/sent',
      queryParameters: {'page': 1, 'limit': 10},
    ).reply(200, inboxJson);

    final result = await repo.getSent();

    expect(result.items.first.subject, 'Hello');
  });

  test('getEmail maps single DTO to entity', () async {
    adapter.onGet('/email/1').reply(200, inboxJson['data']!.first);

    final result = await repo.getEmail(1);

    expect(result.id, 1);
    expect(result.body, 'World');
  });

  test('sendEmail posts and maps response to entity', () async {
    adapter.onPost('/email').reply(200, inboxJson['data']!.first);

    final result = await repo.sendEmail(
      recipientEmail: 'bob@example.com',
      subject: 'Hello',
      body: 'World',
    );

    expect(result.subject, 'Hello');
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```
flutter test test/features/mail/data/mail_repository_impl_test.dart
```

Expected: FAIL — `Target of URI doesn't exist: mail_repository_impl.dart`

- [ ] **Step 3: Create `MailRepositoryImpl`**

```dart
import 'package:core_app/features/mail/data/dtos/email_message_dto.dart';
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/domain/repositories/mail_repository.dart';
import 'package:core_app/models/paginated.dart';
import 'package:dio/dio.dart';

class MailRepositoryImpl implements MailRepository {
  const MailRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<Paginated<EmailMessage>> getInbox({int page = 1, int limit = 10}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/email/inbox',
      queryParameters: <String, dynamic>{'page': page, 'limit': limit},
    );
    return Paginated<EmailMessageDto>.fromJson(res.data!, EmailMessageDto.fromJson)
        .map((dto) => dto.toEntity());
  }

  @override
  Future<Paginated<EmailMessage>> getSent({int page = 1, int limit = 10}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/email/sent',
      queryParameters: <String, dynamic>{'page': page, 'limit': limit},
    );
    return Paginated<EmailMessageDto>.fromJson(res.data!, EmailMessageDto.fromJson)
        .map((dto) => dto.toEntity());
  }

  @override
  Future<EmailMessage> getEmail(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('/email/$id');
    return EmailMessageDto.fromJson(res.data!).toEntity();
  }

  @override
  Future<EmailMessage> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/email',
      data: <String, dynamic>{
        'recipientEmail': recipientEmail,
        'subject': subject,
        'body': body,
      },
    );
    return EmailMessageDto.fromJson(res.data!).toEntity();
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

```
flutter test test/features/mail/data/mail_repository_impl_test.dart
```

Expected: 4 tests PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/mail/data/mail_repository_impl.dart \
        test/features/mail/data/mail_repository_impl_test.dart
git commit -m "feat: add MailRepositoryImpl with integration tests"
```

---

## Task 10: Create presentation providers and run code generation

**Files:**
- Create: `lib/features/mail/presentation/providers/mail_providers.dart`
- Create: `lib/features/mail/presentation/providers/compose_notifier.dart`

- [ ] **Step 1: Create `mail_providers.dart`**

```dart
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
MailRepository mailRepository(Ref ref) =>
    MailRepositoryImpl(ref.watch(dioProvider));

@riverpod
GetInboxUseCase getInboxUseCase(Ref ref) =>
    GetInboxUseCase(ref.watch(mailRepositoryProvider));

@riverpod
GetSentUseCase getSentUseCase(Ref ref) =>
    GetSentUseCase(ref.watch(mailRepositoryProvider));

@riverpod
GetEmailDetailUseCase getEmailDetailUseCase(Ref ref) =>
    GetEmailDetailUseCase(ref.watch(mailRepositoryProvider));

@riverpod
SendEmailUseCase sendEmailUseCase(Ref ref) =>
    SendEmailUseCase(ref.watch(mailRepositoryProvider));

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

- [ ] **Step 2: Create `compose_notifier.dart`**

```dart
import 'package:core_app/features/mail/presentation/providers/mail_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compose_notifier.g.dart';

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
    state = await AsyncValue.guard(
      () => ref.read(sendEmailUseCaseProvider).call(
            recipientEmail: recipientEmail,
            subject: subject,
            body: body,
          ),
    );
  }
}
```

- [ ] **Step 3: Run code generation**

```
dart run build_runner build --delete-conflicting-outputs
```

Expected: generates `mail_providers.g.dart` and `compose_notifier.g.dart`

- [ ] **Step 4: Verify compilation**

```
flutter analyze lib/features/mail/presentation/providers/
```

Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/features/mail/presentation/providers/
git commit -m "feat: add mail presentation providers and ComposeNotifier"
```

---

## Task 11: Move screens and widgets to presentation sublayer

Copy each file to its new location, update all imports inside each file from the old paths to the new paths.

**Files:**
- Create: `lib/features/mail/presentation/screens/inbox_screen.dart`
- Create: `lib/features/mail/presentation/screens/email_detail_screen.dart`
- Create: `lib/features/mail/presentation/screens/compose_screen.dart`
- Create: `lib/features/mail/presentation/widgets/email_tile.dart`
- Create: `lib/features/mail/presentation/widgets/mail_list_view.dart`

- [ ] **Step 1: Create `presentation/widgets/email_tile.dart`**

Copy from `lib/features/mail/widgets/email_tile.dart` with updated imports:

```dart
import 'package:core_app/core/utils/time_utils.dart';
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:flutter/material.dart';

class EmailTile extends StatelessWidget {
  const EmailTile({
    super.key,
    required this.email,
    this.isSentMode = false,
    this.onTap,
  });

  final EmailMessage email;
  final bool isSentMode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = isSentMode
        ? 'To: ${email.recipientUsername}'
        : email.senderUsername;
    final initials =
        (isSentMode ? email.recipientUsername : email.senderUsername)
            .substring(0, 1)
            .toUpperCase();
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];
    final avatarColor =
        colors[(isSentMode ? email.recipientUsername : email.senderUsername)
                .hashCode %
            colors.length];

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: avatarColor,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            formatRelativeTime(email.createdAt),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          if (isSentMode) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.done_all,
                              color: Color(0xFF4CAF50),
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email.subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    email.body,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Create `presentation/widgets/mail_list_view.dart`**

```dart
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/presentation/widgets/email_tile.dart';
import 'package:core_app/models/paginated.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MailListView extends ConsumerWidget {
  const MailListView({
    super.key,
    required this.provider,
    this.isSentMode = false,
  });

  final AutoDisposeFutureProvider<Paginated<EmailMessage>> provider;
  final bool isSentMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mailState = ref.watch(provider);

    return mailState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (page) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(provider),
        child: ListView.separated(
          itemCount: page.items.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            indent: 86,
            endIndent: 20,
            color: Color(0xFFF1F3F9),
          ),
          itemBuilder: (context, index) {
            final email = page.items[index];
            return EmailTile(
              email: email,
              isSentMode: isSentMode,
              onTap: () => context.go('/mail/${email.id}'),
            );
          },
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Create `presentation/screens/inbox_screen.dart`**

Copy from `lib/features/mail/inbox_screen.dart`, updating the import from `mail_providers.dart` to `presentation/providers/mail_providers.dart` and the widget import from `widgets/mail_list_view.dart` to `presentation/widgets/mail_list_view.dart`:

```dart
import 'package:core_app/features/mail/presentation/providers/mail_providers.dart';
import 'package:core_app/features/mail/presentation/widgets/mail_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _title = 'Inbox';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _title = _tabController.index == 0 ? 'Inbox' : 'Sent';
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: Color(0xFFF44336),
                      radius: 22,
                      child: Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                    onPressed: () => context.go('/mail/compose'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  tabs: const [
                    Tab(text: 'Inbox'),
                    Tab(text: 'Sent'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MailListView(provider: inboxProvider()),
                  MailListView(provider: sentMailProvider(), isSentMode: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Create `presentation/screens/email_detail_screen.dart`**

Copy from `lib/features/mail/email_detail_screen.dart`, updating imports:

```dart
import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/presentation/providers/mail_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailDetailScreen extends ConsumerWidget {
  const EmailDetailScreen({required this.emailId, super.key});

  final int emailId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailDetailProvider(emailId));
    return Scaffold(
      appBar: AppBar(title: const Text('Email')),
      body: email.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (message) => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _EmailHeader(message: message),
            const _ReceiptCard(),
          ],
        ),
      ),
    );
  }
}

class _EmailHeader extends StatelessWidget {
  const _EmailHeader({required this.message});
  final EmailMessage message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.subject,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Text(
                message.senderUsername[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderUsername,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'To: ${message.recipientUsername} · Just now',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ReceiptItem extends StatelessWidget {
  const _ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 14)),
              Text(
                '× $quantity',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          Text(price, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🧾 ', style: TextStyle(fontSize: 16)),
              Text(
                'Order Receipt',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 32),
          const _ReceiptItem(
            name: 'Apple AirPods',
            quantity: 2,
            price: '฿8,980',
          ),
          const _ReceiptItem(
            name: 'Apple MagSafe Battery',
            quantity: 1,
            price: '฿3,490',
          ),
          const Divider(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '฿12,470',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'March 5, 2026 at 10:32 AM',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Create `presentation/screens/compose_screen.dart`**

Copy from `lib/features/mail/compose_screen.dart`, replacing the direct `mailRepositoryProvider` call with `ComposeNotifier`, and updating imports:

```dart
import 'package:core_app/features/mail/presentation/providers/compose_notifier.dart';
import 'package:core_app/features/mail/presentation/providers/mail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComposeScreen extends HookConsumerWidget {
  const ComposeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipients = useState(<String>[]);
    final subject = useTextEditingController();
    final body = useTextEditingController();
    final isFormattingActive = useState(false);

    ref.listen(composeNotifierProvider, (prev, next) {
      if (next is AsyncData && prev is AsyncLoading) {
        ref.invalidate(inboxProvider());
        if (context.mounted) context.pop();
      }
      if (next is AsyncError) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Send failed: ${next.error}')),
          );
        }
      }
    });

    final sending = ref.watch(
      composeNotifierProvider.select((s) => s is AsyncLoading),
    );

    Future<void> send() async {
      await ref.read(composeNotifierProvider.notifier).send(
            recipientEmail: recipients.value.join(','),
            subject: subject.text.trim(),
            body: body.text.trim(),
          );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _ComposeHeader(
              onCancel: () => context.pop(),
              onSend: send,
              isSendEnabled: recipients.value.isNotEmpty && !sending,
            ),
            _RecipientSection(recipients: recipients),
            _SubjectSection(controller: subject),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: body,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Body',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            if (isFormattingActive.value) _FormattingToolbar(bodyController: body),
          ],
        ),
      ),
    );
  }
}
```

> **Note:** The `_ComposeHeader`, `_RecipientSection`, `_SubjectSection`, and `_FormattingToolbar` private classes already exist in the old `compose_screen.dart`. Copy them verbatim into the new file below the `ComposeScreen` class. Only the `build` method above changes.

- [ ] **Step 6: Verify compilation**

```
flutter analyze lib/features/mail/presentation/
```

Expected: `No issues found!`

- [ ] **Step 7: Commit**

```bash
git add lib/features/mail/presentation/screens/ \
        lib/features/mail/presentation/widgets/
git commit -m "feat: move mail screens and widgets to presentation sublayer"
```

---

## Task 12: Update router imports

**Files:**
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Update the three mail screen imports**

In `lib/core/router/app_router.dart`, replace:

```dart
import 'package:core_app/features/mail/compose_screen.dart';
import 'package:core_app/features/mail/email_detail_screen.dart';
import 'package:core_app/features/mail/inbox_screen.dart';
```

With:

```dart
import 'package:core_app/features/mail/presentation/screens/compose_screen.dart';
import 'package:core_app/features/mail/presentation/screens/email_detail_screen.dart';
import 'package:core_app/features/mail/presentation/screens/inbox_screen.dart';
```

- [ ] **Step 2: Verify compilation**

```
flutter analyze lib/core/router/app_router.dart
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/core/router/app_router.dart
git commit -m "chore: update router to import screens from presentation sublayer"
```

---

## Task 13: Delete old files and update existing test

**Files:**
- Delete: `lib/features/mail/mail_repository.dart`
- Delete: `lib/features/mail/mail_providers.dart`
- Delete: `lib/features/mail/mail_providers.g.dart`
- Delete: `lib/features/mail/inbox_screen.dart`
- Delete: `lib/features/mail/email_detail_screen.dart`
- Delete: `lib/features/mail/compose_screen.dart`
- Delete: `lib/features/mail/widgets/email_tile.dart`
- Delete: `lib/features/mail/widgets/mail_list_view.dart`
- Delete: `lib/models/email_message.dart`
- Delete: `lib/models/email_message.freezed.dart`
- Delete: `lib/models/email_message.g.dart`
- Modify: `test/models/email_message_test.dart`

- [ ] **Step 1: Delete old mail feature files**

```bash
rm lib/features/mail/mail_repository.dart \
   lib/features/mail/mail_providers.dart \
   lib/features/mail/mail_providers.g.dart \
   lib/features/mail/inbox_screen.dart \
   lib/features/mail/email_detail_screen.dart \
   lib/features/mail/compose_screen.dart \
   lib/features/mail/widgets/email_tile.dart \
   lib/features/mail/widgets/mail_list_view.dart
rmdir lib/features/mail/widgets
```

- [ ] **Step 2: Delete old global email_message model**

```bash
rm lib/models/email_message.dart \
   lib/models/email_message.freezed.dart \
   lib/models/email_message.g.dart
```

- [ ] **Step 3: Update `test/models/email_message_test.dart` to test the DTO**

Replace the entire file content with:

```dart
import 'package:core_app/features/mail/data/dtos/email_message_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('EmailMessageDto parses inbox item shape and maps to entity', () {
    final json = <String, dynamic>{
      'id': 1,
      'senderId': 0,
      'senderUsername': 'system',
      'recipientId': 1,
      'recipientUsername': 'user1',
      'subject': 'Test Push',
      'body': 'Hello!',
      'createdAt': '2026-03-05T04:30:00.000Z',
    };

    final dto = EmailMessageDto.fromJson(json);
    expect(dto.id, 1);
    expect(dto.senderUsername, 'system');
    expect(dto.createdAt.year, 2026);

    final entity = dto.toEntity();
    expect(entity.id, 1);
    expect(entity.senderUsername, 'system');
    expect(entity.subject, 'Test Push');
  });
}
```

- [ ] **Step 4: Run all tests**

```
flutter test
```

Expected: all tests PASS, no compile errors

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "chore: delete old mail files and update email_message_test to test DTO"
```

---

## Task 14: Final verification

- [ ] **Step 1: Run full analysis**

```
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 2: Run full test suite**

```
flutter test
```

Expected: all tests PASS

- [ ] **Step 3: Verify the app builds**

```
flutter build apk --debug 2>&1 | tail -5
```

Expected: `Built build/app/outputs/flutter-apk/app-debug.apk`

- [ ] **Step 4: Commit if any fixups were needed**

If step 1-3 required any changes:

```bash
git add -A
git commit -m "fix: resolve any remaining analysis issues after Clean Architecture migration"
```
