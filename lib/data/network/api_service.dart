import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/customer/addnopel_response.dart';
import 'package:mylm/data/models/user_profile/detail_profile_response.dart';
import 'package:mylm/data/models/auth_&_otp/login_response.dart';
import 'package:mylm/data/models/auth_&_otp/otp_request_response.dart';
import 'package:mylm/data/models/auth_&_otp/verify_otp_response.dart';
import 'package:mylm/data/models/product/promotion_response.dart';
import 'package:mylm/data/models/product/packages_response.dart';
import 'package:mylm/data/models/customer/register_cust/register_customer_request.dart';
import 'package:mylm/data/models/customer/register_cust/register_customer_response.dart';
import 'package:mylm/data/models/support/term_conditions_response.dart';
import 'package:mylm/data/models/bill/bill_list_response.dart';
import 'package:mylm/screen/auth_otp/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mylm/data/models/product/exists_package_response.dart';
import 'package:mylm/data/models/product/upgrade_package_response.dart';
import 'package:mylm/data/network/check_server_status.dart';
import 'package:mylm/data/models/support/faq_response.dart';
import 'package:mylm/data/models/customer/custlist_response.dart';
import 'package:mylm/data/models/notification/notification_response.dart';
import 'package:mylm/data/models/bill/bill_last_response.dart';
import 'package:mylm/data/models/bill/url_bill_response.dart';
import 'package:mylm/data/models/bill/detail_bill_response.dart';


enum OtpMode {
  login,
  addCustomer,
}
class ApiService {
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
        return OtpResponse.fromJson(jsonDecode(response.body)..addAll({
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
        accessToken:  accessToken,
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


// PROFILE
  Future<DetailProfileResponse?> getProfile(
      String custNumber,
      String accessToken,
      BuildContext context,
      ) async {

    if (!await checkServerStatus(context)) {
      return null;
    }

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

  //EXISTS PACKAGES
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


  // FAQS
  Future<List<Faq>> getFaqs(String accessToken) async {
    final url = Uri.parse('$baseUrl/faqs');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("GET FAQ Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> faqList = body['data'];
      return faqList.map((e) => Faq.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat FAQ (code: ${response.statusCode})");
    }
  }


  // TERM CONDITIONS
  Future<TermConditionsResponse?> getTermConditions() async {
    try {
      final url = Uri.parse("$baseUrl/term-conditions");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return TermConditionsResponse.fromJson(jsonBody);
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

  // ADD NEW ID CUSTOMER
  Future<AddNopelResponse?> addNopel({
    required String custNumber,
    required String custGroupId,
    required String newCustNumber,
    required String accessToken,
  }) async {
    final url = "$baseUrl/added-nopel";

    try {
      final body = {
        "cust_number": custNumber,
        "group_id": custGroupId.isEmpty ? "" : custGroupId,
        "cust_number_new": newCustNumber,
      };

      print("=== SEND ADD NOPEL BODY ===");
      print(body);

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("ADD Nopel Response: ${res.statusCode} - ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        return AddNopelResponse.fromJson(jsonDecode(res.body));
      }

      return null;
    } catch (e) {
      print("ADD NOPEL ERROR: $e");
      return null;
    }
  }

  // CUSTOMER LIST
  Future<GetCustListResponse?> getCustomerList({
    required String accessToken,
    required String groupId,
  }) async {
    try {
      final url = Uri.parse(
        "$baseUrl/cust-list?group_id=$groupId",
      );

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
        },
      );

      debugPrint("RAW RESPONSE BODY");
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        debugPrint("GET CUSTOMER LIST SUCCESS");
        return GetCustListResponse.fromJson(jsonBody);
      } else {
        debugPrint("GET CUSTOMER LIST FAILED: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("ERROR Get Customer List: $e");
      return null;
    }
  }


  // NOTIFICATION
  Future<List<NotificationItem>> getNotifications({
    required String accessToken,
    required String custNumber,
  }) async {
    final url = Uri.parse("$baseUrl/notifications?cust_number=$custNumber");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<dynamic> list = jsonData["data"];
      return list.map((e) => NotificationItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch notifications: ${response.body}");
    }
  }

  // READ NOTIFICATION
  Future<bool> readNotification({
    required String accessToken,
    required int notificationId,
  }) async {
    final url = Uri.parse("$baseUrl/read-notification");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "notification_id": notificationId,
      }),
    );

    if (response.statusCode == 200) {
      return true; // sukses
    } else {
      return false;
    }
  }

  // BILL LAST
  Future<List<BillItem>> getBillLast({
    required String accessToken,
    required String custNumber,
  }) async {
    final url = Uri.parse(
      "$baseUrl/bill-last?cust_number=$custNumber",
    );

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final list = jsonData["data"] as List<dynamic>;
      return list.map((e) => BillItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch bill last: ${response.body}");
    }
  }


  // URL BILL
  Future<UrlBillResponse> getUrlBill({
    required String accessToken,
    required String custNumber,
  }) async {
    final url = Uri.parse(
      "$baseUrl/url-paybill?cust_number=$custNumber",
    );

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UrlBillResponse.fromJson(json);
    } else {
      throw Exception("Failed to fetch url pay bill: ${response.body}");
    }
  }

  // DETAIL BILL
  Future<DetailBillResponse> getDetailBill({
    required String accessToken,
    required String piNumber,
  }) async {

    final response = await http.post(
      Uri.parse("$baseUrl/detail-bill"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "pi_number": piNumber,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      if (json["success"] == 1) {
        return DetailBillResponse.fromJson(json);
      } else {
        throw Exception(json["message"] ?? "Gagal memuat detail bill");
      }
    } else {
      throw Exception("Gagal memuat detail bill");
    }
  }

}


