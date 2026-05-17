import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'package:mylm/screen/guest/main_preview_screen.dart';
import 'package:mylm/screen/main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }


  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    final token = await SecureStorage.getAccessToken(); print("Token tersimpan: $token");
    final custNumber = await SecureStorage.getCustNumber();
    final custGroupId = await SecureStorage.getCustGroupId();


    if (!mounted) return;

    if (token != null
        && token.isNotEmpty
        && custNumber != null
        && custNumber.isNotEmpty) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(
            accessToken: token,
            custNumber: custNumber,
            custGroupId: custGroupId ?? "",
          ),
        ),
      );
    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPreviewScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/mylm_logo.png',
          width: 200.w,
          height: 200.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
