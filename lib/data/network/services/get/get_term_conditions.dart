import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/support/term_conditions_response.dart';
import 'package:flutter/material.dart';

class TermConditionsService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";


  // TERM CONDITIONS
  Future<TermConditionsResponse?> getTermConditions() async {
    try {
      final url = Uri.parse("$baseUrl/term-conditions");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return TermConditionsResponse.fromJson(jsonBody);
      } else {
        debugPrint("Gagal memuat term conditions: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Error saat mengambil term conditions: $e");
      return null;
    }
  }
}