import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/screen/main/main_screen.dart';
import 'package:mylm/data/network/api_service.dart';

class VerifyScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;


  const VerifyScreen({super.key,
    required this.custNumber,
    required this.accessToken});


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
    debugPrint("✅ VerifyScreen opened with:");
    debugPrint("Customer Number: ${widget.custNumber}");
    debugPrint("Access Token: ${widget.accessToken}");
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
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() async {
    String otp = _controllers.map((c) => c.text).join();
    debugPrint("OTP Entered: $otp");

    final api = ApiService();
    final response = await api.verifyOtp(widget.custNumber, otp, widget.accessToken);

    //Jika response null atau tidak verified
    if (response == null || response.data?.statusOTP?.toLowerCase() != "verified") {
      debugPrint("OTP Salah atau tidak ditemukan (tetap di VerifyScreen)");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode OTP salah")),
      );
      return; // keluar, jangan lanjut
    }

    // Jika berhasil
    debugPrint("OTP Verified: ${response.data?.statusOTP}");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }






  bool get isValid => _controllers.every((c) => c.text.isNotEmpty);

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
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
            const SizedBox(height: 10),
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
                height: 1.4.h,
              ),
            ),
            SizedBox(height: 20.h),

            // OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60.w,
                  child: TextField(
                    cursorColor: Colors.grey[600],
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF6B00), // orange
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) => _onOtpChanged(value, index),
                  ),
                );
              }),
            ),

            SizedBox(height: 20.h),

            // Timer text
            if (!_canResend) ...[
              Center(
                child: Text(
                  "Masukkan kode Sebelum $_formattedTime ",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],

            // Button Verifikasi
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

            SizedBox(height: 16.h),

            // Kirim ulang kode OTP (selalu ada)
            GestureDetector(
              onTap: _canResend
                  ? () {
                _startTimer();
                debugPrint("Kirim ulang OTP");
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
