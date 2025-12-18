import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mylm/base/lifemedia_colors.dart';

bool _isNoInternetSheetShown = false;

Future<bool> checkInternetConnection(
    BuildContext context, {
      VoidCallback? onConnected,
    }) async {
  try {
    final response = await http
        .get(Uri.parse('https://clients3.google.com/generate_204'))
        .timeout(const Duration(seconds: 3));

    if (response.statusCode == 204) {
      _closeNoInternetSheet(context);
      onConnected?.call();
      return true;
    } else {
      _showNoInternetOnce(context, onConnected);
      return false;
    }
  } on SocketException {
    _showNoInternetOnce(context, onConnected);
    return false;
  } on TimeoutException {
    _showNoInternetOnce(context, onConnected);
    return false;
  } catch (_) {
    _showNoInternetOnce(context, onConnected);
    return false;
  }
}


void _showNoInternetOnce(
    BuildContext context,
    VoidCallback? onConnected,
    ) {
  if (_isNoInternetSheetShown) return;
  _isNoInternetSheetShown = true;

  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48.w, color: darkorange),
            SizedBox(height: 20.h),

            Text(
              "Kamu tidak terhubung ke internet",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 10.h),

            Text(
              "Periksa koneksi internet kamu\nlalu coba muat ulang.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),

            SizedBox(height: 28.h),

            GestureDetector(
              onTap: () {
                checkInternetConnection(
                  context,
                  onConnected: onConnected,
                );
              },
              child: Container(
                height: 48.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  gradient: const LinearGradient(
                    colors: [darkorange, orange],
                  ),
                ),
                child: Text(
                  "Muat Ulang",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  ).whenComplete(() {
    _isNoInternetSheetShown = false;
  });
}


void _closeNoInternetSheet(BuildContext context) {
  if (_isNoInternetSheetShown && Navigator.canPop(context)) {
    Navigator.pop(context);
    _isNoInternetSheetShown = false;
  }
}
