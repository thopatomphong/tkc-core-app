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
