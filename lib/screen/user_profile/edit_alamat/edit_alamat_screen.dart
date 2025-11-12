import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/screen/user_profile/edit_alamat/tambah_alamat_screen.dart';
import 'package:mylm/screen/user_profile/edit_alamat/ubah_alamat_screen.dart';

class EditAlamatScreen extends StatefulWidget {
  const EditAlamatScreen({super.key});

  @override
  State<EditAlamatScreen> createState() => _EditAlamatScreenState();
}

class _EditAlamatScreenState extends State<EditAlamatScreen> {
  int? selectedIndex;

  final List<String> alamatList = [
    "Kost Sholeh, Jalan Mangga, Kocoran, Caturtunggal, Depok, Kab Sleman, DIY, 559312",
    "Kost Baik, Jalan Banjarsari, Dukuh, Gedongkiwo, Mantrijeron, Kota Yogyakarta, DIY, 559312",
    "Kost Cerdas, Jalan Mangga, Kocoran, Caturtunggal, Kasihan, Kab Bantul, DIY, 559312",
  ];

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
          "Alamat Saya",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TambahAlamatScreen()));
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/icons_map_add.svg",
                  width: 24.w,
                  height: 24.h,
                  colorFilter:
                  const ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                ),
                SizedBox(width: 6.w),
                Text(
                  "Tambah Alamat Baru",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            ),
            SizedBox(height: 16.h),

            Text(
              "Alamat",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),

            // Daftar alamat
            Expanded(
              child: ListView.builder(
                itemCount: alamatList.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.orange.withValues(alpha: 0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.orange.withValues(alpha: 0.3)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Container(
                              margin: EdgeInsets.only(bottom: 6.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                "Utama",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          Text(
                            alamatList[index],
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: 130.w,
                            height: 36.h,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const UbahAlamatScreen()));
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(EdgeInsets.zero),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                    Colors.transparent),
                                elevation: WidgetStateProperty.all(0),
                              ),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [darkorange, orange],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Center(
                                  child: Text(
                                    "Ubah Alamat",
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250.w,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedIndex == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pilih salah satu alamat terlebih dahulu."),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Alamat ${selectedIndex! + 1} berhasil dipilih!",
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  }
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
                      "Pilih Alamat",
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
          ],
        ),
      ),
    );
  }
}
