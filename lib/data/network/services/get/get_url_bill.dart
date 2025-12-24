import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/bill/url_bill_response.dart';

class UrlBillService {
  static const String baseUrl = "http://202.169.224.27:3004/api/v1/apps";

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
}