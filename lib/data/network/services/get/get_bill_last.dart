import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/bill/bill_last_response.dart';

class BillLastService {
  static const String baseUrl = "http://202.169.224.27:3004/api/v1/apps";

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
}
