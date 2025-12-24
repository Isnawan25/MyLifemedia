import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/product/promotion_response.dart';

class PromotionService {
  static const String baseUrl = "http://202.169.224.27:3004/api/v1/apps";

  // PROMOTION
  Future<List<Promotion>> getPromotions() async {
    final response = await http.get(Uri.parse('$baseUrl/promotions'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> promoList = data['data'];
      return promoList.map((e) => Promotion.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data promosi");
    }
  }
}