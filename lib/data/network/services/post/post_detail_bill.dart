import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/bill/detail_bill_response.dart';

class DetailBillService {
  static const String baseUrl = "http://202.169.224.27:3004/api/v1/apps";

  // DETAIL BILL
  Future<DetailBillResponse> getDetailBill({
    required String accessToken,
    required String piNumber,
  }) async {

    final response = await http.post(
      Uri.parse("$baseUrl/detail-bill"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "pi_number": piNumber,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      if (json["success"] == 1) {
        return DetailBillResponse.fromJson(json);
      } else {
        throw Exception(json["message"] ?? "Gagal memuat detail bill");
      }
    } else {
      throw Exception("Gagal memuat detail bill");
    }
  }
}
