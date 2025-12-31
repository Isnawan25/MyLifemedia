import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';
import 'package:mylm/data/network/services/get/get_notifications.dart';
import 'package:mylm/data/network/services/post/post_read_notifications.dart';
import 'package:mylm/data/preferences/secure_storage.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsService notificationsService;
  final ReadNotificationsService readNotificationsService;

  String _accessToken = "";
  String _custNumber = "";

  final Set<int> _readIds = {};

  NotificationsCubit({
    required this.notificationsService,
    required this.readNotificationsService,
  }) : super(NotificationsInitial());

  /// load user + fetch notifications
  Future<void> load() async {
    emit(NotificationsLoading());

    final token = await SecureStorage.getAccessToken();
    final cust = await SecureStorage.getCustNumber();

    if (token == null || cust == null) {
      emit(NotificationsError("User tidak ditemukan"));
      return;
    }

    _accessToken = token;
    _custNumber = cust;

    await fetchNotifications();
  }

  /// fetch list notifikasi
  Future<void> fetchNotifications() async {
    try {
      final result = await notificationsService.getNotifications(
        accessToken: _accessToken,
        custNumber: _custNumber,
      );

      _readIds.clear();
      for (final n in result) {
        final status = n.notificationStatus.toLowerCase();
        if (status == 'read' || status == '1') {
          _readIds.add(n.notificationId);
        }
      }

      emit(
        NotificationsLoaded(
          notifications: result,
          readIds: Set.from(_readIds),
        ),
      );
    } catch (e) {
      emit(NotificationsError("Gagal memuat notifikasi"));
    }
  }

  /// mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      final ok = await readNotificationsService.readNotification(
        accessToken: _accessToken,
        notificationId: notificationId,
      );

      if (ok) {
        _readIds.add(notificationId);

        if (state is NotificationsLoaded) {
          final current = state as NotificationsLoaded;
          emit(
            NotificationsLoaded(
              notifications: current.notifications,
              readIds: Set.from(_readIds),
            ),
          );
        }
      }
    } catch (_) {
      // silent fail, UX tetap aman
    }
  }
}
