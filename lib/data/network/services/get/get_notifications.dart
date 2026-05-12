import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mylm/data/models/notification/notification_response.dart';

class NotificationsService {
  static const String baseUrl = "http://103.157.26.55:3004/api/v1/apps";

  // NOTIFICATION
  Future<List<NotificationItem>> getNotifications({
    required String accessToken,
    required String custNumber,
  }) async {
    final url = Uri.parse("$baseUrl/notifications?cust_number=$custNumber");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<dynamic> list = jsonData["data"];
      return list.map((e) => NotificationItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch notifications: ${response.body}");
    }
  }
}