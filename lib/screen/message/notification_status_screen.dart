import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/data/models/notification/notification_response.dart';
import 'package:mylm/base/date_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationStatusScreen extends StatelessWidget {
  final NotificationItem notification;
  final Future<void> Function()? onMarkAsRead;

  const NotificationStatusScreen({
    super.key,
    required this.notification,
    this.onMarkAsRead,
  });

  IconData _selectIcon(String typeOrTitle) {
    final lower = typeOrTitle.toLowerCase();
    if (lower.contains("payment") || lower.contains("pembayaran") || lower == 'payment') {
      return Icons.receipt_long_rounded;
    }
    if (lower.contains("request") || lower.contains("permintaan") || lower == 'request') {
      return Icons.assignment_rounded;
    }
    if (lower.contains("process") || lower.contains("proses") || lower == 'process') {
      return Icons.access_time_filled_rounded;
    }
    if (lower.contains("berhasil") || lower.contains("sukses")) {
      return Icons.check_circle_rounded;
    }
    return Icons.info_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final icon = _selectIcon(notification.notificationType);
    final waktuFormatted = formatTanggalWaktu(notification.notificationUpdateAt);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () async {
            if (onMarkAsRead != null) await onMarkAsRead!();
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(12.w),
           child: IconButton(
              icon: SvgPicture.asset(
                "assets/svgs/arrow_back.svg",
                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text('Pesan', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [darkorange, orange]),
                  ),
                  child: Icon(icon, color: Colors.white, size: 40.sp),
                ),
                SizedBox(height: 20.h),
                Text(
                  notification.notificationTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                SizedBox(height: 8.h),
                Text(
                  notification.notificationDesc,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[700], height: 1.4),
                ),
                SizedBox(height: 20.h),
                Text(
                  waktuFormatted,
                  style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[500]),
                ),
                if (notification.notificationPINumber.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Text("Ref: ${notification.notificationPINumber}", style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[700])),
                  ),

                if (notification.notificationType.toLowerCase() == 'payment')
                  Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: SizedBox(
                      width: 200.w,
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () {
                          // untuk ke detail tagihan
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                          backgroundColor: null,
                          padding: EdgeInsets.zero,
                        ),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [darkorange, orange]),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Center(child: Text("Detail Tagihan", style: GoogleFonts.inter(color: Colors.white))),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
