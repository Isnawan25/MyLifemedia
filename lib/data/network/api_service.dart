import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/user_profile/detail_profile_response.dart';
import 'package:mylm/data/models/auth_&_otp/login_response.dart';
import 'package:mylm/data/models/auth_&_otp/otp_request_response.dart';
import 'package:mylm/data/models/auth_&_otp/verify_otp_response.dart';
import 'package:mylm/data/models/product/promotion_response.dart';
import 'package:mylm/data/models/product/packages_response.dart';
import 'package:mylm/data/models/product/register%20cust/register_customer_request.dart';
import 'package:mylm/data/models/product/register%20cust/register_customer_response.dart';
import 'package:mylm/data/models/support/term_conditions_response.dart';
import 'package:dio/dio.dart';
import 'package:mylm/data/models/bill/bill_list_response.dart';
import 'package:mylm/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mylm/data/models/product/exists_package_response.dart';
import 'package:mylm/data/models/product/upgrade_package_response.dart';



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

  // RESEND OTP
  Future<OtpResponse?> resendOtp(String custNumber, String accessToken) async {
    debugPrint("Mengirim ulang OTP ke nomor: $custNumber");
    return await requestOtp(custNumber, accessToken);
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

      if (response.statusCode != 201) {
        debugPrint("Verify OTP gagal: kode status tidak diharapkan (${response.statusCode})");
        return null;
      }

      final decoded = jsonDecode(response.body);

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


// GET PROFILE
  Future<DetailProfileResponse?> getProfile(
      String custNumber,
      String accessToken,
      BuildContext context,
      ) async {
    final url = Uri.parse("$baseUrl/detailprofile?cust_number=$custNumber");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      print("GET Profile Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        return DetailProfileResponse.fromJson(jsonDecode(response.body));

      } else if (response.statusCode == 401) {
        print("Token expired atau tidak valid, menghapus token dan kembali ke login.");

        final storage = const FlutterSecureStorage();
        await storage.delete(key: 'access_token');

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
        }
        return null;

      } else {
        print("Gagal ambil profil: ${response.statusCode}");
        return null;}
    }
    catch (e) {
      print("Error GET Profile: $e");
      return null;}
  }


  // GET PROMOTION
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

  // GET PACKAGES
  Future<GetPackagesResponse?> getPackages() async {
    final url = Uri.parse("$baseUrl/packages");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("GET Packages Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        return GetPackagesResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        print("Gagal ambil packages: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error GET Packages: $e");
      return null;
    }
  }

  //GET EXISTS PACKAGES
  Future<ExistsPackage?> getExistingPackage(String groupId, String custNumber, String accessToken)
  async {
    final url = Uri.parse("$baseUrl/exists-package""?group_id=$groupId&cust_number=$custNumber",
    );
    try {
      final response = await http.get(
          url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
      );
      print("RAW JSON EXISTS PACKAGE:");
      print(response.body);


      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == 1 && data["data"] is List && data["data"].isNotEmpty) {
          // Ambil yang cocok dengan custNumber

          final pkg = (data["data"] as List).firstWhere(
                  (e) => e["custNumber"] == custNumber,
              orElse: () => null
          );

          if (pkg == null) return null;
          return ExistsPackage.fromJson(pkg);
        }
      }
      return null;
    } catch (e) {
      print("Error get Existing Package: $e");
      return null;
    }

  }

  // UPGRADE PACKAGES
  Future<UpgradePackageResponse> upgradePackage({
    required String accessToken,
    required String custNumber,
    required String custName,
    required String custPhone,
    required String custEmail,
    required String custProvince,
    required String custDistrict,
    required String custSubDistrict,
    required String custVillage,
    required String custAddress,
    required String custSpCodeIdExists,
    required String custSpCodeIdNew,
  }) async {
    final url = Uri.parse("$baseUrl/upgrade-package");

    print("=== START UPGRADE PACKAGE REQUEST ===");
    print("custNumber: $custNumber");
    print("custSpCodeIdExists: $custSpCodeIdExists");
    print("custSpCodeIdNew: $custSpCodeIdNew");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "custNumber": custNumber,
        "custName": custName,
        "custPhone": custPhone,
        "custEmail": custEmail,
        "custProvince": custProvince,
        "custDistrict": custDistrict,
        "custSubDistrict": custSubDistrict,
        "custVillage": custVillage,
        "custAddress": custAddress,
        "custSpCodeIdExists": custSpCodeIdExists,
        "custSpCodeIdNew": custSpCodeIdNew,
      }),
    );

    print("=== UPGRADE PACKAGE RESPONSE ===");
    print(response.body);

    final decoded = jsonDecode(response.body);

    // Jika bukan 200, maka lempar error
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(decoded['message'] ?? "Upgrade package failed");
    }

    return UpgradePackageResponse.fromJson(decoded);
  }


  // REGISTER CUSTOMERS
  Future<RegisterCustomerResponse> registerCustomer(RegisterCustomerRequest request) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse["success"] == 1) {
        return RegisterCustomerResponse.fromJson(jsonResponse);
      } else {
        throw Exception("Failed to register customer: ${jsonResponse["message"]}");
      }
    } else {
      throw Exception("HTTP Error ${response.statusCode}: ${response.body}");
    }
  }

  // TERM CONDITIONS
  Future<TermConditionsResponse?> getTermConditions() async {
    try {
      final dio = Dio();
      final response = await dio.get("$baseUrl/term-conditions");

      if (response.statusCode == 200) {
        return TermConditionsResponse.fromJson(response.data);
      } else {
        debugPrint("Gagal memuat term conditions: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Error saat mengambil term conditions: $e");
      return null;
    }
  }

  // BILL LIST
  Future<BillListResponse> getBillList({
    required String custNumber,
    required String custGroupId,
    required String accessToken,
  })
  async {
    final url = Uri.parse('$baseUrl/bill-list?cust_number=$custNumber&group_id=$custGroupId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return BillListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load bill list: ${response.body}');
    }
  }

}


