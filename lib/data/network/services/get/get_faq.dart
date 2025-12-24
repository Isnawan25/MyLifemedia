import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/support/faq_response.dart';

class FaqService {
  static const String baseUrl = "http://202.169.224.27:3004/api/v1/apps";

  // FAQS
  Future<List<Faq>> getFaqs(String accessToken) async {
    final url = Uri.parse('$baseUrl/faqs');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("GET FAQ Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> faqList = body['data'];
      return faqList.map((e) => Faq.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat FAQ (code: ${response.statusCode})");
    }
  }
}