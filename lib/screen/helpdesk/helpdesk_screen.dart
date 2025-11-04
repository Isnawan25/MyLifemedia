import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/screen/main/main_screen.dart';

class HelpdeskScreen extends StatelessWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;

  const HelpdeskScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.custGroupId,
  });

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
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScreen(
                  custNumber: custNumber,
                  accessToken: accessToken,
                  custGroupId: custGroupId,
                )
                )
            );
          },
        ),
        title: Text(
          "Helpdesk Life Media",
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
          "assets/images/helpdesk_logo.png",
          height: 250.h,
        ),

        Text(
          "Butuh bantuan lebih lanjut?\nTim kami siap membantu Anda",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

          SizedBox(height: 40.h),

          Center(
            child: Material(
              borderRadius: BorderRadius.circular(30.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(30.r),
                onTap: () {
                print("Go to Whatsapps");
                },
                child: Container(
                  width: 250.w,
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 40.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    gradient: const LinearGradient(
                      colors: [(darkorange), (orange)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Hubungi",
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
      ]
    )
      )
    );
  }
}

