import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/customer/register_cust/register_customer_request.dart';
import 'package:mylm/data/models/customer/register_cust/register_customer_response.dart';

class RegisterCustomerService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";


  // REGISTER CUSTOMERS
  Future<RegisterCustomerResponse> registerCustomer(
      RegisterCustomerRequest request) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse["success"] == 1) {
        return RegisterCustomerResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
            "Failed to register customer: ${jsonResponse["message"]}");
      }
    } else {
      throw Exception("HTTP Error ${response.statusCode}: ${response.body}");
    }
  }
}