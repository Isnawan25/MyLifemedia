import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';

class EditNomorScreen extends StatefulWidget {
  const EditNomorScreen({super.key});

  @override
  State<EditNomorScreen> createState() => _EditNomorScreenState();
}

class _EditNomorScreenState extends State<EditNomorScreen> {
  final TextEditingController _nomorController = TextEditingController();

  @override
  void dispose() {
    _nomorController.dispose();
    super.dispose();
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Ganti No. Handphone",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Masukkan Nomor Handphone Anda untuk ditampilkan di profil.",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),

            Text(
              "No. Handphone",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),

            TextField(
              controller: _nomorController,
              decoration: InputDecoration(
                hintText: "No. Handphone",
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey.shade400,
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Tombol Simpan
            Center(
              child: SizedBox(
                width: 300.w,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    //hubungkan ke API update nama
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nomor berhasil disimpan!")),
                    );
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor:
                    WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [darkorange, orange],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(
                      child: Text(
                        "Simpan",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
