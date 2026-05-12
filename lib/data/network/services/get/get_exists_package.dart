import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/product/exists_package_response.dart';

class ExistsPackageService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";

  //EXISTS PACKAGES
  Future<ExistsPackage?> getExistingPackage(String groupId, String custNumber,
      String accessToken) async {
    final url = Uri.parse(
      "$baseUrl/exists-package""?group_id=$groupId&cust_number=$custNumber",
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

        if (data["success"] == 1 && data["data"] is List &&
            data["data"].isNotEmpty) {
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
}