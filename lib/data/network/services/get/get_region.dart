import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/customer/register_cust/region_response.dart';

class RegionService {

  static const String baseUrl = "http://103.157.26.55:3004";

  // GET PROVINCES
  Future<RegionResponse> getProvinces() async {

    final url = Uri.parse(
      "$baseUrl/api/v1/apps/provinces",
    );

    final response = await http.get(url);

    final jsonResponse =
    jsonDecode(response.body);

    if (response.statusCode == 200) {

      return RegionResponse.fromJson(
        jsonResponse,
      );

    } else {

      throw Exception(
        "Failed get provinces",
      );
    }
  }


  // GET REGENCIES
  Future<RegionResponse> getRegencies(
      String provinceId,
      ) async {

    final url = Uri.parse(
      "$baseUrl/api/v1/apps/regencies?province_id=$provinceId",
    );

    final response = await http.post(url);

    final jsonResponse =
    jsonDecode(response.body);

    if (response.statusCode == 201) {

      return RegionResponse.fromJson(
        jsonResponse,
      );

    } else {

      throw Exception(
        "Failed get regencies",
      );
    }
  }


  // GET DISTRICTS
  Future<RegionResponse> getDistricts(
      String regencyId,
      ) async {

    final url = Uri.parse(
      "$baseUrl/api/v1/apps/districts?regency_id=$regencyId",
    );

    final response = await http.post(url);

    final jsonResponse =
    jsonDecode(response.body);

    if (response.statusCode == 201) {

      return RegionResponse.fromJson(
        jsonResponse,
      );

    } else {

      throw Exception(
        "Failed get districts",
      );
    }
  }


  // GET VILLAGES
  Future<RegionResponse> getVillages(
      String districtId,
      ) async {

    final url = Uri.parse(
      "$baseUrl/api/v1/apps/villages?district_id=$districtId",
    );

    final response = await http.post(url);

    final jsonResponse =
    jsonDecode(response.body);

    if (response.statusCode == 201) {

      return RegionResponse.fromJson(
        jsonResponse,
      );

    } else {

      throw Exception(
        "Failed get villages",
      );
    }
  }
}