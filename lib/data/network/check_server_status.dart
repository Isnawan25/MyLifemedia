import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';

Future<bool> checkServerStatus(BuildContext context) async {
  const baseUrl = "http://202.169.224.27:3004";

  try {
    final response = await http.get(
      Uri.parse(baseUrl),
    ).timeout(const Duration(seconds: 3));

    if (response.statusCode == 200 || response.statusCode == 404) {
      // Server nyala (walaupun 404 tetap berarti hidup)
      return true;
    } else {
      // Status lain dianggap bermasalah
      showServerDownSheet(context);
      return false;
    }
  } on SocketException catch (_) {
    showServerDownSheet(context);
    return false;
  } on HttpException catch (_) {
    showServerDownSheet(context);
    return false;
  } on TimeoutException catch (_) {
    showServerDownSheet(context);
    return false;
  } catch (e) {
    showServerDownSheet(context);
    return false;
  }
}

void showServerDownSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 90.w,
                  color: Colors.orange.withValues(alpha: 0.25),
                ),
                Icon(
                  Icons.build_circle_rounded,
                  size: 60.w,
                  color: darkorange,
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Judul
            Text(
              "Server Maintenance",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 10.h),

            // Deskripsi
            Text(
              "Server sedang dalam perbaikan.\nSilakan coba lagi nanti.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),

            SizedBox(height: 28.h),

            // Tombol Tutup
            GestureDetector(
              onTap: () {
                SystemNavigator.pop();
              },
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  gradient: const LinearGradient(
                    colors: [darkorange, orange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Tutup",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 8.h),
          ],
        ),
      );
    },
  );
}
