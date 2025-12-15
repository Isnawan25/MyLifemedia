import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/popup/toast.dart';
import 'package:mylm/screen/add_nopel/success_bottomsheet.dart';
import 'package:mylm/screen/main/main_screen.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/data/preferences/secure_storage.dart';

class VerifyScreen extends StatefulWidget {
  final String mainCustNumber;
  final String custNumber;
  final String accessToken;
  final String custGroupId;
  final String newCustNumber;
  final OtpMode mode;

  const VerifyScreen({
    super.key,
    required this.mainCustNumber,
    required this.accessToken,
    required this.custNumber,
    required this.custGroupId,
    required this.newCustNumber,
    required this.mode,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    debugPrint("VERIFY SCREEN OPENED");
    debugPrint("Cust Number (OTP target): ${widget.custNumber}");
    debugPrint("Main Cust Number (Add Nopel): ${widget.mainCustNumber}");
    debugPrint("Group ID: ${widget.custGroupId}");
    debugPrint("Mode: ${widget.mode}");
  }

  String get _formattedTime {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        _timer?.cancel();
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }

    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    String otp = _controllers.map((c) => c.text).join();
    debugPrint("OTP Input: $otp");

    final api = ApiService();
    final response = await api.verifyOtp(
      custNumber: widget.custNumber,
      otp: otp,
      accessToken: widget.accessToken,
      mode: widget.mode,
    );

    // otp gagal
    if (response == null || response.data?.statusOTP.toLowerCase() != "verified") {
      debugPrint("OTP verification FAILED");
      showCustomErrorToast(context, "Kode OTP kamu salah");
      return;
    }

    debugPrint("=== OTP VERIFIED SUCCESS ===");

    // mode login
    if (widget.mode == OtpMode.login) {
      debugPrint("Processing LOGIN MODE...");

      await SecureStorage.saveAccessToken(widget.accessToken);
      await SecureStorage.saveCustNumber(widget.custNumber);
      await SecureStorage.saveCustGroupId(widget.custGroupId);

      debugPrint("Token & Customer Data Saved!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(
            custNumber: widget.custNumber,
            accessToken: widget.accessToken,
            custGroupId: widget.custGroupId,
          ),
        ),
      );
      return;
    }

    // mode add customer
    if (widget.mode == OtpMode.addCustomer) {
      debugPrint("Processing ADD CUSTOMER MODE...");
      debugPrint("Calling addNopel API...");

      final addResp = await api.addNopel(
        custNumber: widget.mainCustNumber,    // ID utama
        newCustNumber: widget.custNumber,     // ID baru
        custGroupId: widget.custGroupId,
        accessToken: widget.accessToken,
      );

      if (addResp == null || addResp.success != 1) {
        debugPrint("ADD NOPEL FAILED");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menambahkan ID pelanggan")),
        );
        return;
      }

      debugPrint("ADD NOPEL SUCCESS");
      debugPrint("Generated Nopel: ${addResp.data?.nopel}");
      debugPrint("Generated Group ID: ${addResp.data?.groupId}");

      await SecureStorage.saveCustGroupId(addResp.data!.groupId);

      Navigator.pop(context);

      Future.delayed(const Duration(milliseconds: 200), () {
        showAddCustomerSuccessBottomSheet(
          context,
          nopel: addResp.data!.nopel,
        );
      });
    }
  }

  bool get isValid => _controllers.every((c) => c.text.isNotEmpty);

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
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
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.pop(context),
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
            Text(
              "Verifikasi Akun",
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Silahkan masukan nomor OTP yang telah dikirimkan pada nomor telepon Anda",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30.h),

            // OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60.w,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: darkorange,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (v) => _onOtpChanged(v, index),
                  ),
                );
              }),
            ),

            SizedBox(height: 25.h),

            if (!_canResend)
              Center(
                child: Text(
                  "Masukkan kode sebelum $_formattedTime",
                  style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
                ),
              ),

            SizedBox(height: 25.h),

            // Tombol Verifikasi
            GestureDetector(
              onTap: isValid ? _verifyOtp : null,
              child: Center(
                child: Container(
                  width: 250.w,
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
                    "Verifikasi",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isValid ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Resend OTP
            GestureDetector(
              onTap: _canResend
                  ? () async {
                _startTimer();
                await ApiService().resendOtp(
                  custNumber: widget.custNumber,
                  accessToken: widget.accessToken,
                  mode: widget.mode,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Kode OTP telah dikirim ulang")),
                );
              }
                  : null,
              child: Center(
                child: Text(
                  "Kirim ulang kode OTP",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: _canResend ? Colors.red : Colors.grey,
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
