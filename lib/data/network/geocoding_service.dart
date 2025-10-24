import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  /// Mengambil alamat berdasarkan latitude & longitude menggunakan OSM (Nominatim)
  static Future<Map<String, dynamic>?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json&addressdetails=1');

    final response = await http.get(
      url,
      headers: {'User-Agent': 'FlutterApp (rifai25saputra@gmail.com)'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['address'];
    } else {
      print("Reverse geocoding gagal: ${response.statusCode}");
      return null;
    }
  }
}
