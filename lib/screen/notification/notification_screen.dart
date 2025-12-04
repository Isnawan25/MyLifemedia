import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/data/models/notification/notification_response.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'package:mylm/screen/notification/notification_status_screen.dart';
import 'package:mylm/base/date_formatter.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ApiService apiService = ApiService();

  List<NotificationItem> notifications = [];
  bool isLoading = true;
  bool isError = false;

  String accessToken = "";
  String custNumber = "";

  // local set untuk status baca
  final Set<int> _readIds = {};

  @override
  void initState() {
    super.initState();
    loadUserAndFetch();
  }

  Future<void> loadUserAndFetch() async {
    final token = await SecureStorage.getAccessToken();
    final cust = await SecureStorage.getCustNumber();

    if (token == null || cust == null) {

      setState(() {
        isError = true;
        isLoading = false;
      });
      return;
    }

    accessToken = token;
    custNumber = cust;

    await fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final result = await apiService.getNotifications(
        accessToken: accessToken,
        custNumber: custNumber,
      );

      // isi read set dari field notificationStatus
      _readIds.clear();
      for (var n in result) {
        if (n.notificationStatus.toLowerCase() == 'read' ||
            n.notificationStatus.toLowerCase() == '1') {
          _readIds.add(n.notificationId);
        }
      }

      setState(() {
        notifications = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("fetchNotifications error: $e");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(int notificationId) async {
    try {
      final ok = await apiService.readNotification(
        accessToken: accessToken,
        notificationId: notificationId,
      );
      if (ok) {
        setState(() => _readIds.add(notificationId));
      } else {
        debugPrint("readNotification returned false for $notificationId");
      }
    } catch (e) {
      debugPrint("readNotification error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgs/arrow_back.svg",
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pesan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Tidak ada Notifikasi"),
            const SizedBox(height: 8)
          ],
        ),
      )
          : ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        itemCount: notifications.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1.h, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final isRead = _readIds.contains(notif.notificationId);

          return InkWell(
            onTap: () async {
              await _markAsRead(notif.notificationId);

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationStatusScreen(
                    notification: notif,
                    onMarkAsRead: () async {
                      await _markAsRead(notif.notificationId);
                    },
                  ),
                ),
              );
              // refresh
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isRead)
                    Container(
                      width: 10.w,
                      height: 10.w,
                      margin: EdgeInsets.only(top: 6.h, right: 12.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    SizedBox(width: 22.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notif.notificationTitle,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight:
                            isRead ? FontWeight.w400 : FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          notif.notificationDesc,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    formatNotifikasiShort(notif.notificationUpdateAt),
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
