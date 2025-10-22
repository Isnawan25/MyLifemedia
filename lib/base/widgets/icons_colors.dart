import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:google_fonts/google_fonts.dart';


Widget buildFeature(BuildContext context, String svgPath, String title,
    {VoidCallback? onTap}) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: onTap,
    child: Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [darkorange, orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: SvgPicture.asset(
            svgPath,
            width: 45.w,
            height: 45.h,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}