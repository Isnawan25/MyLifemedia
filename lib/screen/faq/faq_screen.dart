import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/screen/faq/detail_faq1_screen.dart';
import 'package:mylm/screen/faq/detail_faq2_screen.dart';
import 'package:mylm/screen/faq/detail_faq3_screen.dart';
import 'package:mylm/screen/faq/detail_faq4_screen.dart';
import 'package:mylm/screen/faq/detail_faq5_screen.dart';
import 'package:mylm/screen/main/main_screen.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> daftarBantuan = [
      "Cara pembayaran tagihan Life Media",
      "Kenapa link tagihan saya tidak bisa dibuka?",
      "Kenapa saya tidak bisa koneksi internet?",
      "Kenapa lampu LOS di modem saya menyala merah atau berkedip?",
      "Kenapa kecepatan internet saya lebih lambat dari yang seharusnya?",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
        title: Text(
          "Bantuan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 🔍 Pencarian
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cari Bantuan",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 📋 Daftar FAQ
            Expanded(
              child: ListView.builder(
                itemCount: daftarBantuan.length,
                itemBuilder: (context, index) {
                  final judul = daftarBantuan[index];

                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          title: Text(
                            judul,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.black54,
                          ),
                          onTap: () {
                            // 🔹 Arahkan ke halaman berbeda tergantung index
                            Widget halamanTujuan;

                            switch (index) {
                              case 0:
                                halamanTujuan = DetailFaq1Screen(judulBantuan: judul);
                                break;
                              case 1:
                                halamanTujuan = DetailFaq2Screen(judulBantuan: judul);
                                break;
                              case 2 :
                                halamanTujuan = DetailFaq3Screen(judulBantuan: judul);
                                break ;
                              case 3 :
                                halamanTujuan = DetailFaq4Screen(judulBantuan: judul);
                                break;
                              case 4 :
                                halamanTujuan = DetailFaq5Screen(judulBantuan: judul);
                                break;
                                default:
                              halamanTujuan = DetailFaq1Screen(judulBantuan: judul);
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => halamanTujuan,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
