import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/data/models/customer/register_cust/region_response.dart';

Widget buildDropdownField({
  required String title,
  required RegionModel? value,
  required List<RegionModel> items,
  required VoidCallback? onTap,
}) {

  return Padding(
    padding: EdgeInsets.only(bottom: 16.h),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        // LABEL
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),

        SizedBox(height: 6.h),

        // DROPDOWN
        InkWell(
          borderRadius: BorderRadius.circular(16),

          onTap: onTap,

          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18.w,
              vertical: 18.h,
            ),

            decoration: BoxDecoration(
              color: Colors.grey.shade100,

              borderRadius:
              BorderRadius.circular(16),

              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),

            child: Row(
              children: [

                Expanded(
                  child: Text(

                    value?.name ?? "Pilih $title",

                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,

                      color: value == null
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),

                RotatedBox(
                  quarterTurns: 2,

                  child: SvgPicture.asset(
                    "assets/svgs/arrow_back.svg",

                    width: 18.w,

                    colorFilter:
                    const ColorFilter.mode(
                      Colors.black54,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Future<RegionModel?> showRegionBottomSheet({
  required BuildContext context,
  required String title,
  required List<RegionModel> items,
}) async {

  return await showModalBottomSheet<RegionModel>(
    context: context,

    backgroundColor: Colors.white,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),

    builder: (context) {

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              Text(
                title,

                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 20.h),

              Flexible(
                child: ListView.separated(

                  shrinkWrap: true,

                  itemCount: items.length,

                  separatorBuilder:
                      (_, __) => Divider(
                    color: Colors.grey.shade300,
                  ),

                  itemBuilder: (context, index) {

                    final item = items[index];

                    return InkWell(

                      onTap: () {
                        Navigator.pop(
                          context,
                          item,
                        );
                      },

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                        ),

                        child: Text(
                          item.name,

                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}