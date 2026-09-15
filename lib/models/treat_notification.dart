enum NotificationCategory {
  all,
  plattersAndFeasts,
  squadAndLudo,
  flashDrops,
  receipts,
  community,
}

class TreatNotification {
  final String id;
  final String categoryLabel;
  final NotificationCategory category;
  final String timeAgo;
  final String title;
  final String description;
  bool isRead;
  final String? primaryActionText;
  final String? secondaryActionText;
  final String actionType; // 'slip', 'ludo', 'deal', 'receipt', 'reply'
  bool isLoved;

  TreatNotification({
    required this.id,
    required this.categoryLabel,
    required this.category,
    required this.timeAgo,
    required this.title,
    required this.description,
    this.isRead = false,
    this.primaryActionText,
    this.secondaryActionText,
    required this.actionType,
    this.isLoved = false,
  });
}
