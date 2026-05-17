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
