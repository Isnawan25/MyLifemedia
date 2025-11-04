import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/date_formatter.dart';
import 'package:mylm/base/lifemedia_colors.dart';

class DetailTagihanScreen extends StatelessWidget {
  final String paketInternet;
  final String Periode;
  final String Pembayaran;
  final String idTagihan;
  final String harga;
  final String status;
  final String tanggalPembayaran;

  const DetailTagihanScreen({
    super.key,
    required this.paketInternet,
    required this.Periode,
    required this.Pembayaran,
    required this.idTagihan,
    required this.harga,
    required this.status,
    required this.tanggalPembayaran,
  });

  bool get isMenunggu => status.contains("Menunggu");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgs/arrow_back.svg",
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Tagihan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [darkorange, orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(18.w),
                child: SvgPicture.asset(
                  isMenunggu
                      ? "assets/svgs/icons_three_dots.svg"
                      : "assets/svgs/icons_invoice2.svg",
                  colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              isMenunggu ? "Menunggu Pembayaran" : "Sudah Dibayar",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              "ID Tagihan: $idTagihan",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              harga,
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 32.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rincian Tagihan",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _detailItem("Paket Internet", paketInternet),
                  _detailItem("Periode", Periode),
                  _detailItem("Pembayaran", Pembayaran),
                  _detailItem("Harga", harga),
                  _detailItem("Status", status),
                  _detailItem("Tanggal Pembayaran", formatTanggalWaktu(tanggalPembayaran)),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
