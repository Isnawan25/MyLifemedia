import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/date_formatter.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:mylm/data/network/services/get/get_notifications.dart';
import 'package:mylm/data/network/services/post/post_read_notifications.dart';
import 'package:mylm/screen/main/notification/notification_status_screen.dart';
import 'package:mylm/data/cubit/notification/notification_cubit.dart';
import 'package:mylm/data/cubit/notification/notification_state.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(
        notificationsService: NotificationsService(),
        readNotificationsService: ReadNotificationsService(),
      )..load(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: SvgPicture.asset(
              "assets/svgs/arrow_back.svg",
              colorFilter:
              const ColorFilter.mode(Colors.black, BlendMode.srcIn),
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
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return _skeletonList();
            }

            if (state is NotificationsError) {
              return const Center(
                child: Text("Tidak ada Notifikasi"),
              );
            }

            if (state is NotificationsLoaded) {
              final notifications = state.notifications;
              final readIds = state.readIds;

              if (notifications.isEmpty) {
                return const Center(
                  child: Text("Tidak ada Notifikasi"),
                );
              }

              return ListView.separated(
                padding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                itemCount: notifications.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1.h, color: Colors.grey[300]),
                itemBuilder: (_, index) {
                  final notif = notifications[index];
                  final isRead =
                  readIds.contains(notif.notificationId);

                  return InkWell(
                    onTap: () async {
                      context
                          .read<NotificationsCubit>()
                          .markAsRead(notif.notificationId);

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationStatusScreen(
                            notification: notif,
                            onMarkAsRead: () async {
                              context
                                  .read<NotificationsCubit>()
                                  .markAsRead(
                                  notif.notificationId,);
                            },
                          ),
                        ),
                      );
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
                              margin:
                              EdgeInsets.only(top: 6.h, right: 12.w),
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
                                    fontWeight: isRead
                                        ? FontWeight.w400
                                        : FontWeight.w600,
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
                            formatNotifikasiShort(
                                notif.notificationUpdateAt),
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
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _skeletonList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      itemCount: 2,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, __) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SkeletonLoading(width: 10.w, height: 10.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoading(
                        width: double.infinity, height: 14.h),
                    SizedBox(height: 8.h),
                    SkeletonLoading(width: 180.w, height: 12.h),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              SkeletonLoading(width: 40.w, height: 12.h),
            ],
          ),
        );
      },
    );
  }
}
