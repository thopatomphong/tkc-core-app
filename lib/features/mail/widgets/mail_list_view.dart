import 'package:core_app/features/mail/widgets/email_tile.dart';
import 'package:core_app/models/email_message.dart';
import 'package:core_app/models/paginated.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MailListView extends ConsumerWidget {
  const MailListView({super.key, required this.provider, this.isSentMode = false});

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
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 86, endIndent: 20, color: Color(0xFFF1F3F9)),
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
