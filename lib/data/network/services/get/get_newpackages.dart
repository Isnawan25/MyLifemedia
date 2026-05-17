import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/product/newpackages_response.dart';

class GetNewPackagesService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";

  Future<NewPackagesResponse?> getNewPackages() async {
    try {
      final url = Uri.parse('$baseUrl/newpackages');

      final response = await http.get(url);

      print("GET NEW PACKAGES: ${response.statusCode}");
      print(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        return NewPackagesResponse.fromJson(jsonResponse);
      }

      return null;
    } catch (e) {
      print("GET NEW PACKAGES ERROR: $e");
      return null;
    }
  }
}