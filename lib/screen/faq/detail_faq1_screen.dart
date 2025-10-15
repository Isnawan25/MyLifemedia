import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/lifemedia_text.dart';
import 'package:mylm/screen/main/main_screen.dart';

class DetailFaq1Screen extends StatelessWidget {
  final String judulBantuan;

  const DetailFaq1Screen({super.key, required this.judulBantuan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgs/arrow_back.svg",
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Detail Bantuan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      // ================= BODY =================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Cara pembayaran tagihan Life Media",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Anda bisa membayar tagihan Life Media melalui beberapa metode:",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
            FAQ1,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                height: 1,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Silakan masuk ke menu Tagihan di aplikasi untuk melihat detail pembayaran.",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),

            // ================= BUTTON =================
            Center(
              child: Container(
                width: 300.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  gradient: const LinearGradient(
                    colors: [(darkorange), (orange)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // nanti bisa diarahkan ke halaman bantuan utama
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    "Butuh Bantuan Lainnya?",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
