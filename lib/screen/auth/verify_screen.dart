import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/popup/toast.dart';
import 'package:mylm/data/network/services/post/post_auth_otp.dart';
import 'package:mylm/screen/main/add_nopel/success_bottomsheet.dart';
import 'package:mylm/screen/main/main_screen.dart';
import 'package:mylm/data/cubit/verify/verify_state.dart';
import 'package:mylm/data/cubit/verify/verify_cubit.dart';

class VerifyScreen extends StatefulWidget {
  final String mainCustNumber;
  final String custNumber;
  final String accessToken;
  final String custGroupId;
  final String newCustNumber;
  final String password;
  final String custName;
  final String custPhone;
  final String custEmail;
  final String custAddress;
  final String custProvince;
  final String custDistrict;
  final String custSubDistrict;
  final String custVillage;
  final OtpMode mode;

  const VerifyScreen({
    super.key,
    required this.mainCustNumber,
    required this.accessToken,
    required this.custNumber,
    required this.custGroupId,
    required this.newCustNumber,
    required this.password,
    required this.custName,
    required this.custPhone,
    required this.custEmail,
    required this.custAddress,
    required this.custProvince,
    required this.custDistrict,
    required this.custSubDistrict,
    required this.custVillage,
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

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // auto verify
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyOtp();
    }
  }

  void _verifyOtp() {
    final otp = _controllers.map((c) => c.text).join();

    context.read<VerifyCubit>().verifyOtp(
      otp: otp,
      custNumber: widget.custNumber,
      accessToken: widget.accessToken,
      custGroupId: widget.custGroupId,
      mainCustNumber: widget.mainCustNumber,
      newCustNumber: widget.newCustNumber,
      mode: widget.mode,

      password: widget.password,
      custName: widget.custName,
      custPhone: widget.custPhone,
      custEmail: widget.custEmail,
      custAddress: widget.custAddress,
      custProvince: widget.custProvince,
      custDistrict: widget.custDistrict,
      custSubDistrict: widget.custSubDistrict,
      custVillage: widget.custVillage,
    );
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
    return BlocListener<VerifyCubit, VerifyState>(
        listener: (context, state) {
          if (state is VerifyError) {
            showCustomErrorToast(context, state.message);
          }

          if (state is VerifySuccessLogin) {
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
          }

          if (state is VerifySuccessAddCustomer) {
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 200), () {
              showAddCustomerSuccessBottomSheet(
                context,
                nopel: state.nopel,
              );
            });
          }
        },
        child: Scaffold(
      appBar: AppBar(
        elevation: 0.w,
        backgroundColor: Colors.white,
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


            const SizedBox(height: 16),

            // Resend OTP
            GestureDetector(
              onTap: _canResend
                  ? () {
                _startTimer();
                context.read<VerifyCubit>().resendOtp(
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
    )
    );
  }
}