import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/bill/bill_list_response.dart';

class BillListService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";

  // BILL LIST
  Future<BillListResponse> getBillList({
    required String custNumber,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/bill-list?cust_number=$custNumber');

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