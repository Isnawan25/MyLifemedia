class NotificationItem {
  final int notificationId;
  final String notificationTitle;
  final String notificationDesc;
  final String notificationType;
  final String notificationStatus;
  final String notificationUpdateAt;
  final String notificationPINumber;
  final String notificationCustNumber;

  NotificationItem({
    required this.notificationId,
    required this.notificationTitle,
    required this.notificationDesc,
    required this.notificationType,
    required this.notificationStatus,
    required this.notificationUpdateAt,
    required this.notificationPINumber,
    required this.notificationCustNumber,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notificationId'],
      notificationTitle: json['notificationTitle'],
      notificationDesc: json['notificationDesc'],
      notificationType: json['notificationType'],
      notificationStatus: json['notificationStatus'],
      notificationUpdateAt: json['notificationUpdateAt'],
      notificationPINumber: json['notificationPINumber'],
      notificationCustNumber: json['notificationCustNumber'],
    );
  }
}
