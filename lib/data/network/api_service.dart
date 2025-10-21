import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:mylm/data/models/detail_profile_response.dart';
import 'package:mylm/data/models/login_response.dart';
import 'package:mylm/data/models/otp_request_response.dart';
import 'package:mylm/data/models/verify_otp_response.dart';
import 'package:mylm/data/models/promotion_response.dart';

class ApiService {
  static const String baseUrl = "http://202.169.231.66:83/api-mylm-nestjs/apps/api/v1/apps";

  /// LOGIN
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
  Future<OtpResponse?> requestOtp(String custNumber, String accessToken) async {
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
        return OtpResponse.fromJson(jsonDecode(response.body));
      } else {
        print("Gagal request OTP: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error saat request OTP: $e");
      return null;
    }
  }


  //VERIFY OTP
  Future<VerifyOtpResponse?> verifyOtp(
      String custNumber,
      String otp,
      String accessToken,
      ) async {
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

      debugPrint("🔹 Verify OTP Response: ${response.statusCode} - ${response.body}");

      //server balas 404 = OTP salah
      if (response.statusCode == 404) {
        debugPrint("OTP Salah, server mengembalikan 404 (Not Found)");
        return null;
      }

      //Jika bukan 201 (Created) = respon tidak valid
      if (response.statusCode != 201) {
        debugPrint("Verify OTP gagal: kode status tidak diharapkan (${response.statusCode})");
        return null;
      }

      //Parse JSON
      final decoded = jsonDecode(response.body);

      //Validasi struktur & status
      if (decoded["success"] == 1 &&
          decoded["data"]?["statusOTP"]?.toString().toLowerCase() == "verified") {
        debugPrint("OTP Verified dari server");
        return VerifyOtpResponse.fromJson(decoded);
      }

      debugPrint("Response tidak mengandung status 'verified'.");
      return null;
    } catch (e) {
      debugPrint("Error Verify OTP: $e");
      return null;
    }
  }





  // DETAIL RPOFILE
  Future<DetailProfileResponse?> getDetailProfile(
      String custNumber,
      String accessToken,
      ) async {
    final url = Uri.parse(
        "$baseUrl/detailprofile?cust_number=$custNumber");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // penting!
        },
      );

      print("🔹 GET DetailProfile Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        return DetailProfileResponse.fromJson(jsonDecode(response.body));
      } else {
        print(" Gagal GET DetailProfile: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print(" Error saat GET DetailProfile: $e");
      return null;
    }
  }


  // PROMOTION
  Future<List<Promotion>> getPromotions() async {
    final response = await http.get(Uri.parse('$baseUrl/promotions'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> promoList = data['data'];
      return promoList.map((e) => Promotion.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data promosi");
    }
  }

}


