import 'dart:convert';
import 'package:http/http.dart' as http;

class ReadNotificationsService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";

  // READ NOTIFICATION
  Future<bool> readNotification({
    required String accessToken,
    required int notificationId,
  }) async {
    final url = Uri.parse("$baseUrl/read-notification");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "notification_id": notificationId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}