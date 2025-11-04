import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BayarTagihanEmptyScreen extends StatelessWidget {
  const BayarTagihanEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
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
            "Pembayaran Tagihan",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/no_empty_logo.png",
                    height: 200.h,
                  ),
                  Center(
                  child: Text(
                    "Belum ada Tagihan untuk saat ini",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  )
                ]
            )
        )
    );
  }
}

