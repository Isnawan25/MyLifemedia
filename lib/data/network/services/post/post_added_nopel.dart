import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/customer/addnopel_response.dart';

class AddedNopelService {
  static const String baseUrl =
      "http://103.157.26.55:3004/api/v1/apps";

  // ADD NEW ID CUSTOMER
  Future<AddNopelResponse?> addNopel({
    required String custNumber,
    required String custGroupId,
    required String newCustNumber,
    required String newCustPassword,
    required String accessToken,
  }) async {
    final url = "$baseUrl/added-nopel";

    try {
      final body = {
        "cust_number": custNumber,
        "group_id": custGroupId,
        "cust_number_new": newCustNumber,
        "cust_password_new": newCustPassword,
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

      print("ADD NOPEL RESPONSE:");
      print(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return AddNopelResponse.fromJson(
          jsonDecode(res.body),
        );
      }

      return null;
    } catch (e) {
      print("ADD NOPEL ERROR: $e");
      return null;
    }
  }
}