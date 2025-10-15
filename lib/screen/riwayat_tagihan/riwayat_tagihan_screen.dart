import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';

class RiwayatTagihanScreen extends StatelessWidget {
  const RiwayatTagihanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> riwayatTagihan = [
      {
        "id": "PILM0005",
        "harga": "Rp 166.500",
        "status": "Menunggu Pembayaran",
      },
      {
        "id": "PILM0004",
        "harga": "Rp 166.500",
        "status": "Sudah dibayar 1 Februari 2025",
      },
      {
        "id": "PILM0003",
        "harga": "Rp 166.500",
        "status": "Sudah dibayar 1 Januari 2025",
      },
      {
        "id": "PILM0002",
        "harga": "Rp 166.500",
        "status": "Sudah dibayar 1 Desember 2024",
      },
      {
        "id": "PILM0001",
        "harga": "Rp 166.500",
        "status": "Sudah dibayar 1 November 2024",
      },
    ];

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
          "Riwayat Tagihan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: ListView.separated(
          itemCount: riwayatTagihan.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final tagihan = riwayatTagihan[index];
            final isMenunggu = tagihan["status"]!.contains("Menunggu");

            return InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () {
                debugPrint("Klik: ${tagihan["id"]}");
              },
              splashColor: Colors.orange.withValues(alpha: 0.15),
              highlightColor: Colors.orange.withValues(alpha: 0.05),
              child: Container(
                padding: EdgeInsets.all(14.w),
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
                child: Row(
                  children: [
                    // === ICON AREA ===
                    isMenunggu
                        ? Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [darkorange, orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: SvgPicture.asset(
                          "assets/svgs/icons_three_dots.svg",
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    )
                    : ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [darkorange, orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: SvgPicture.asset(
                        "assets/svgs/icons_invoice2.svg",
                        width: 32.w,
                        height: 32.w,
                      ),
                    ),


                    SizedBox(width: 12.w),

                    // === INFO TAGIHAN ===
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tagihan["id"]!,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            tagihan["harga"]!,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            tagihan["status"]!,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: isMenunggu
                                  ? Colors.orange[800]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // === PANAH KE KANAN ===
                    Transform.flip(
                      flipX: true,
                      child: SvgPicture.asset(
                        "assets/svgs/arrow_back.svg",
                        width: 16.w,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
