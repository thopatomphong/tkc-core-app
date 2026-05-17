import 'package:core_app/features/mail/mail_providers.dart';
import 'package:core_app/features/mail/widgets/mail_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                    const Text('Inbox', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const CircleAvatar(backgroundColor: Color(0xFFF44336), radius: 22, child: Icon(Icons.edit, color: Colors.white, size: 20)),
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
                  decoration: BoxDecoration(color: const Color(0xFFF1F3F9), borderRadius: BorderRadius.circular(8)),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    tabs: const [Tab(text: 'Inbox'), Tab(text: 'Sent')],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    MailListView(provider: inboxProvider()),
                    MailListView(provider: sentMailProvider(), isSentMode: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
