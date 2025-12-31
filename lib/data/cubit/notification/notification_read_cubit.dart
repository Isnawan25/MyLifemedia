import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/network/services/get/get_notifications.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'notification_read_state.dart';

class NotificationReadCubit extends Cubit<NotificationReadState> {
  NotificationReadCubit() : super(NotificationReadLoading());

  Future<void> check() async {
    final token = await SecureStorage.getAccessToken();
    final cust = await SecureStorage.getCustNumber();
    if (token == null || cust == null) return;

    final result = await NotificationsService().getNotifications(
      accessToken: token,
      custNumber: cust,
    );

    final unread = result.any(
          (n) => n.notificationStatus.toLowerCase() == 'not_read',
    );

    emit(NotificationReadLoaded(unread));
  }
}
