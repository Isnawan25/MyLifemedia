import 'package:mylm/data/models/notification/notification_response.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationItem> notifications;
  final Set<int> readIds;

  NotificationsLoaded({
    required this.notifications,
    required this.readIds,
  });
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}