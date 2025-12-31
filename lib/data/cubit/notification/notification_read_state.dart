abstract class NotificationReadState {}

class NotificationReadLoading extends NotificationReadState {}
class NotificationReadLoaded extends NotificationReadState {
  final bool hasUnread;
  NotificationReadLoaded(this.hasUnread);
}
