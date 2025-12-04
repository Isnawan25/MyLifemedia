import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'package:mylm/screen/auth_otp/verify_screen.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/data/models/auth_&_otp/login_response.dart';
import 'package:mylm/screen/guest/welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  final CustomerData? customerData;
  const LoginScreen({super.key, this.customerData});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _idController.addListener(_validateInput); // pantau input setiap kali berubah
  }

  void _validateInput() {
    String text = _idController.text;

    bool hasLetter = text.contains(RegExp(r'[A-Za-z]'));
    bool hasNumber = text.contains(RegExp(r'[0-9]'));
    bool minLength = text.length >= 6;

    setState(() {
      isValid = hasLetter && hasNumber && minLength;
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.w,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgs/arrow_back.svg",
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
          ),

          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder:
                  (context) => WelcomeScreen()))
        ),
        title: Text(
          "Masuk",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text("Selamat Datang",
                style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 8),
            Text(
              "Silahkan masukan ID pelanggan Anda yang sudah didaftarkan di Life Media",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.4.h,
              ),
            ),
            const SizedBox(height: 30),


            TextField(
              textCapitalization: TextCapitalization.characters,
              cursorColor: Colors.grey[600],
              controller: _idController,
              keyboardType: TextInputType.text,
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
            const SizedBox(height: 30),

            GestureDetector(
              onTap: isValid
                  ? () async {
                final api = ApiService();
                final custNumber = _idController.text.trim();

                // Login
                final result = await api.login(custNumber);

                  if (result != null && result.success) {
                    final customerData = result.data;
                    final accessToken = customerData?.accessToken ?? '';
                    final custGroupId = customerData?.custGroupId ?? '';

                    //  SIMPAN DATA KE SECURE STORAGE
                    await SecureStorage.saveAccessToken(accessToken);
                    await SecureStorage.saveCustNumber(custNumber);
                    await SecureStorage.saveCustGroupId(custGroupId);

                    // Kirim data dari auth
                    await SecureStorage.saveCustName(customerData?.custName ?? '');
                    await SecureStorage.saveCustPhone(customerData?.custPhone ?? '');
                    await SecureStorage.saveCustEmail(customerData?.custEmail ?? '');
                    await SecureStorage.saveCustAddress(customerData?.custAddress ?? '');
                    await SecureStorage.saveCustProvince(customerData?.custProvince ?? '');
                    await SecureStorage.saveCustDistrict(customerData?.custDistrict ?? '');
                    await SecureStorage.saveCustSubDistrict(customerData?.custSubDistrict ?? '');
                    await SecureStorage.saveCustVillage(customerData?.custVillage ?? '');


                  // Request OTP
                  final otpResponse = await api.requestOtp(
                      custNumber: custNumber, accessToken: accessToken, mode: OtpMode.login);

                  if (otpResponse != null && otpResponse.success) {
                    print("OTP Berhasil diminta: ${otpResponse.data?.otp}");

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyScreen(
                          custNumber: custNumber,
                          accessToken: accessToken,
                          custGroupId: custGroupId,
                          mainCustNumber: "",
                          newCustNumber: "",
                          mode: OtpMode.login,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal mengirim OTP.")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Login gagal: ${result?.message ?? 'Server error'}"),
                    ),
                  );
                }
              }
                  : null, // nonaktif jika tidak valid
              child: Center(
              child: Container(
                width: 250.w,
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  gradient: isValid
                      ? const LinearGradient(
                    colors: [
                      darkorange,
                      orange
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                      : null, // aktif jika v
                  color: isValid ? null : Colors.grey[300],
                ),
                child: Text(
                  "Masuk",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isValid ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            )
          ],
        ),
      ),
    );
  }
}
