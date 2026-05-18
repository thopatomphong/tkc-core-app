import 'package:core_app/features/mail/domain/entities/email_message.dart';
import 'package:core_app/features/mail/presentation/widgets/email_tile.dart';
import 'package:core_app/models/paginated.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef MailPageProviderBuilder =
    AutoDisposeFutureProvider<Paginated<EmailMessage>> Function({int page});

class MailListView extends ConsumerStatefulWidget {
  const MailListView({
    super.key,
    required this.provider,
    this.isSentMode = false,
  });

  final MailPageProviderBuilder provider;
  final bool isSentMode;

  @override
  ConsumerState<MailListView> createState() => _MailListViewState();
}

class _MailListViewState extends ConsumerState<MailListView> {
  static const int _pageSize = 10;

  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final pageProvider = widget.provider(page: _page);
    final mailState = ref.watch(pageProvider);

    return mailState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (page) {
        final pageCount = page.total <= 0
            ? 1
            : ((page.total + _pageSize - 1) ~/ _pageSize);
        final displayPage = _page > pageCount ? pageCount : _page;

        if (_page > pageCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _page > pageCount) {
              setState(() {
                _page = pageCount;
              });
            }
          });
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(pageProvider),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      isSentMode: widget.isSentMode,
                      onTap: () => context.go('/mail/${email.id}'),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(
                    tooltip: 'Previous page',
                    onPressed: _page == 1
                        ? null
                        : () => setState(() {
                            _page -= 1;
                          }),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Page $displayPage of $pageCount'),
                  ),
                  IconButton.outlined(
                    tooltip: 'Next page',
                    onPressed: _page >= pageCount
                        ? null
                        : () => setState(() {
                            _page += 1;
                          }),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
