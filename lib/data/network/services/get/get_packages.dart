import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/product/packages_response.dart';

class PackagesService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";

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
}