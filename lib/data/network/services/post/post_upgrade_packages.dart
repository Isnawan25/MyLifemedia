import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/product/upgrade_package_response.dart';
import 'package:mylm/data/models/product/upgrade_package_request.dart';

class UpgradePackageService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";

  // UPGRADE PACKAGES
  Future<UpgradePackageResponse> upgradePackage({
    required String accessToken,
    required UpgradePackageRequest request,
  }) async {
    final url = Uri.parse("$baseUrl/upgrade-package");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(decoded['message'] ?? "Upgrade package failed");
    }

    return UpgradePackageResponse.fromJson(decoded);
  }
}