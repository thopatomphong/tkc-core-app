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
