import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/user_profile/detail_profile_response.dart';
import 'package:mylm/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mylm/data/network/check_server_status.dart';

class ProfileService {
  static const String baseUrl = "http://202.169.224.27:3004/api/v1/apps";

// PROFILE
  Future<DetailProfileResponse?> getProfile(String custNumber,
      String accessToken,
      BuildContext context,) async {
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
        print(
            "Token expired atau tidak valid, menghapus token dan kembali ke login.");

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
        return null;
      }
    }
    catch (e) {
      print("Error GET Profile: $e");
      return null;
    }
  }
}
