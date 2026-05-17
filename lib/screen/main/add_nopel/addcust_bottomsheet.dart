import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/popup/toast.dart';
import 'package:mylm/data/network/services/post/post_added_nopel.dart';
import 'package:mylm/data/network/services/post/post_auth_otp.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'package:mylm/screen/auth/verify_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/cubit/verify/verify_cubit.dart';

Future<Map<String, String>?> showAddCustomerBottomSheet(BuildContext context) {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isValid = false;
  bool obscurePassword = true;

  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void _validateInput() {
            final id = _idController.text.trim();
            final password = _passwordController.text.trim();

            bool hasLetter = id.contains(RegExp(r'[A-Za-z]'));
            bool hasNumber = id.contains(RegExp(r'[0-9]'));
            bool minLength = id.length >= 6;

            setState(() {
              isValid =
                  hasLetter && hasNumber && minLength && password.isNotEmpty;
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
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
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
                  onChanged: (_) => _validateInput(),
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

                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: obscurePassword,
                  cursorColor: Colors.grey[600],
                  onChanged: (_) => _validateInput(),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: GoogleFonts.inter(
                      color: Colors.grey[600],
                    ),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // submit
                GestureDetector(
                  onTap: isValid
                      ? () async {

                    final custNumber = _idController.text.trim();
                    final password = _passwordController.text.trim();

                    final mainGroupId =
                        await SecureStorage.getCustGroupId() ?? "";

                    final mainCustomerNumber =
                        await SecureStorage.getCustNumber() ?? "";

                    final accessToken =
                        await SecureStorage.getAccessToken() ?? "";

                    final addNopelService = AddedNopelService();
                    final api = AuthOtpService();

                    // HIT API ADDED NOPEL
                    final addRes = await addNopelService.addNopel(
                      custNumber: mainCustomerNumber,
                      custGroupId: mainGroupId,
                      newCustNumber: custNumber,
                      newCustPassword: password,
                      accessToken: accessToken,
                    );

                    if (addRes == null || addRes.success != 1) {
                      showCustomErrorToast(
                        context,
                        "Gagal menambahkan ID pelanggan",
                      );
                      return;
                    }

                    // simpan password untuk silent login
                    await SecureStorage.saveCustPassword(
                      custNumber,
                      password,
                    );

                    // REQUEST OTP
                    final otpRes = await api.requestOtp(
                      custNumber: custNumber,
                      accessToken: accessToken,
                      mode: OtpMode.addCustomer,
                    );

                    if (otpRes == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Gagal mengirim OTP."),
                        ),
                      );
                      return;
                    }

                    // tutup bottomsheet
                    Navigator.pop(context, {
                      'nopel': custNumber,
                    });

                    // next verify screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => VerifyCubit(),
                          child: VerifyScreen(
                            mainCustNumber: mainCustomerNumber,
                            custNumber: custNumber,
                            newCustNumber: custNumber,
                            accessToken: accessToken,
                            custGroupId: mainGroupId,
                            mode: OtpMode.addCustomer,
                          ),
                        ),
                      ),
                    );

                  }
                      : null,
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
                        color: Colors.white,
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
