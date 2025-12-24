import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/auth/login_response.dart';
import 'package:mylm/data/models/auth/otp_request_response.dart';
import 'package:mylm/data/models/auth/verify_otp_response.dart';
import 'package:flutter/material.dart';

enum OtpMode {
  login,
  addCustomer,
}

class AuthOtpService {
  static const String baseUrl = "http://202.169.224.27:3004/api/v1/apps";

  // AUTH/LOGIN
  Future<LoginResponse?> login(String custNumber) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"cust_number": custNumber}),
    );

    print(" LOGIN Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      print(" Login failed: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  // REQUEST OTP
  Future<OtpResponse?> requestOtp({
    required String custNumber,
    required String accessToken,
    required OtpMode mode,
  }) async {
    final url = Uri.parse("$baseUrl/request-otp");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"cust_number": custNumber}),
      );

      print("OTP Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OtpResponse.fromJson(jsonDecode(response.body)
          ..addAll({
            "otp_mode": mode.name
          }));
      } else {
        print("Gagal request OTP: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error saat request OTP: $e");
      return null;
    }
  }


  // RESEND OTP
  Future<OtpResponse?> resendOtp({
    required String custNumber,
    required String accessToken,
    required OtpMode mode,
  }) async {
    debugPrint("Mengirim ulang OTP ke nomor: $custNumber");
    return await requestOtp(
        custNumber: custNumber,
        accessToken: accessToken,
        mode: mode
    );
  }


  // VERIFY OTP
  Future<VerifyOtpResponse?> verifyOtp({
    required String custNumber,
    required String otp,
    required String accessToken,
    required OtpMode mode,
  }) async {
    final url = Uri.parse("$baseUrl/verify-otp");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "cust_number": custNumber,
          "otp_code": otp,
        }),
      );

      print("Verify OTP: ${response.statusCode} - ${response.body}");

      if (response.statusCode != 201) return null;

      final decoded = jsonDecode(response.body);
      decoded["otp_mode"] = mode.name;

      return VerifyOtpResponse.fromJson(decoded);
    } catch (e) {
      print("Error Verify OTP: $e");
      return null;
    }
  }
}