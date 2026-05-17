import 'package:core_app/features/mail/presentation/providers/mail_providers.dart';
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
