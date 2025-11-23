import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'package:mylm/screen/auth_otp/verify_screen.dart';

Future<Map<String, String>?> showAddCustomerBottomSheet(BuildContext context) {
  final TextEditingController _idController = TextEditingController();
  bool isValid = false;

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

                // submit
                GestureDetector(
                  onTap: isValid
                      ? () async {
                    final custNumber = _idController.text.trim();
                    final api = ApiService();

                    final mainGroupId =
                        await SecureStorage.getCustGroupId() ?? "";
                    final mainCustomerNumber =
                        await SecureStorage.getCustNumber() ?? "";

                    // login new id
                    final loginRes = await api.login(custNumber);
                    if (loginRes == null || loginRes.data == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("ID Pelanggan tidak ditemukan."),
                        ),
                      );
                      return;
                    }

                    final data = loginRes.data!;

                    // save data ke secure storage
                    await SecureStorage.saveAccessToken(data.accessToken);
                    await SecureStorage.saveCustNumber(data.custNumber);
                    await SecureStorage.saveCustGroupId(data.custGroupId);

                    await SecureStorage.saveCustName(data.custName);
                    await SecureStorage.saveCustPhone(data.custPhone);
                    await SecureStorage.saveCustEmail(data.custEmail);
                    await SecureStorage.saveCustAddress(data.custAddress);

                    await SecureStorage.saveCustProvince(data.custProvince ?? "");
                    await SecureStorage.saveCustDistrict(data.custDistrict ?? "");
                    await SecureStorage.saveCustSubDistrict(data.custSubDistrict ?? "");
                    await SecureStorage.saveCustVillage(data.custVillage ?? "");

                    final token = data.accessToken;

                    // req otp
                    final otpRes = await api.requestOtp(
                      custNumber: data.custNumber,
                      accessToken: token,
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

                    // tutup bottomsheet dengan data
                    Navigator.pop(context, {
                      'custNumber': data.custNumber,
                      'custGroupId': mainGroupId,
                      'accessToken': token,
                    });

                    // next to verify screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyScreen(
                          mainCustNumber: mainCustomerNumber,
                          custNumber: data.custNumber,
                          newCustNumber: data.custNumber,
                          accessToken: token,
                          custGroupId: mainGroupId,
                          mode: OtpMode.addCustomer,
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
