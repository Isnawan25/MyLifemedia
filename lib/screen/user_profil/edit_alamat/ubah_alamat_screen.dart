import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';

class UbahAlamatScreen extends StatelessWidget {
  const UbahAlamatScreen({super.key});

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
          "Alamat Baru",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Alamat",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),

            // TextField: Provinsi, Kota, Kecamatan, Kode Pos
            TextField(
              decoration: InputDecoration(
                hintText: "Provinsi, Kota, Kecamatan, Kode Pos",
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: darkorange),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // TextField: Nama Jalan, Gedung, No Rumah
            TextField(
              decoration: InputDecoration(
                hintText: "Nama Jalan, Gedung, No Rumah",
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: darkorange),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Text(
              "Gunakan Lokasi Saat ini",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),

            // Gambar peta dummy
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/maps_dummy.png",
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/svgs/icons_pin_location.svg",
                        height: 36.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Hapus
                SizedBox(
                  width: 160.w,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Alamat dihapus.")),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      "Hapus Alamat",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),

                // Tombol Simpan
                SizedBox(
                  width: 160.w,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Alamat berhasil disimpan!")),
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
                      elevation: WidgetStateProperty.all(4),
                      backgroundColor: WidgetStateProperty.all(Colors.transparent),
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
                          "Simpan Alamat",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
