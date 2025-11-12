import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';

void showAddCustomerBottomSheet(BuildContext context) {
  final TextEditingController _idController = TextEditingController();
  bool isValid = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void _validateInput(String text) {
            bool hasLetter = text.contains(RegExp(r'[A-Za-z]'));
            bool hasNumber = text.contains(RegExp(r'[0-9]'));
            bool minLength = text.length >= 6;

            setState(() {
              isValid = hasLetter && hasNumber && minLength;
            });
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Masukkan ID Pelanggan MyLifemedia kamu",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _idController,
                  textCapitalization: TextCapitalization.characters,
                  cursorColor: Colors.grey[600],
                  onChanged: _validateInput,
                  decoration: InputDecoration(
                    labelText: "ID Pelanggan",
                    labelStyle: GoogleFonts.inter(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Tombol Submit
                GestureDetector(
                  onTap: isValid
                      ? () async {
                    Navigator.pop(context);
                  }
                      : null,
                  child: Center(
                    child: Container(
                      width: 300.w,
                      height: 50.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        gradient: isValid
                            ? const LinearGradient(
                          colors: [darkorange, orange],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                            : null,
                        color: isValid ? null : Colors.grey[300],
                      ),
                      child: Text(
                        "Tambah ID Pelanggan",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}
