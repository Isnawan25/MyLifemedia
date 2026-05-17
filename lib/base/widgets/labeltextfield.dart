
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegex.hasMatch(email);
}

Widget buildLabeledTextField(String label, TextEditingController controller) {
  final isEmail = label.toLowerCase().contains('email');
  final isPhone = label.toLowerCase().contains('handphone');

  return Padding(
    padding: EdgeInsets.only(bottom: 16.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 6.h),

        TextFormField(
          controller: controller,

          // Keyboard
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : isPhone
              ? TextInputType.phone
              : TextInputType.text,

          // digit angka untuk no. hp
          inputFormatters: isPhone
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,

          textCapitalization:
          isEmail || isPhone
              ? TextCapitalization.none
              : TextCapitalization.words,

          // Validation
          validator: (value) {
            final text = value?.trim() ?? "";


            if (isEmail && !isValidEmail(text)) {
              return "Format email tidak valid (contoh: nama@email.com)";
            }

            if (isPhone && text.length < 10) {
              return "No. Handphone minimal 10 digit";
            }

            return null;
          },

          decoration: InputDecoration(
            hintText: "Masukkan $label",
            hintStyle: GoogleFonts.inter(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    ),
  );
}
