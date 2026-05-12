import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/customer/customer_status_response.dart';

class CustomerStatusService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";

  Future<CustomerStatusResponse?> getCustomerStatus({
    required String custNumber,
  }) async {
    final url = Uri.parse(
      "$baseUrl/customer-status?custNumber=$custNumber",
    );

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData["success"] == 1 &&
          jsonData["data"] != null &&
          jsonData["data"].isNotEmpty) {
        return CustomerStatusResponse.fromJson(
          jsonData["data"][0],
        );
      }
      return null;
    } else {
      throw Exception(
        "Failed to fetch customer status: ${response.body}",
      );
    }
  }
}
