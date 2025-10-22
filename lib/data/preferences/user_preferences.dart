import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> saveUserData({
    required String custNumber,
    required String custName,
    required String custAddress,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custNumber', custNumber);
    await prefs.setString('custName', custName);
    await prefs.setString('custAddress', custAddress);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
