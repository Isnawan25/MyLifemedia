import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mylm/data/models/customer/custlist_response.dart';

class CustListService {
  static const String baseUrl = "http://202.169.224.27:3004/api/v1/apps";

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
}