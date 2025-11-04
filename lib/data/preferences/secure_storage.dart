import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }

  static const _keyCustNumber = 'cust_number';

  static Future<void> saveCustNumber(String number) async {
    await _storage.write(key: _keyCustNumber, value: number);
  }

  static Future<String?> getCustNumber() async {
    return await _storage.read(key: _keyCustNumber);
  }

  static const _keyCustGroupId = 'custGroupId';

  static Future<void> saveCustGroupId(String groupId) async {
    await _storage.write(key: _keyCustGroupId, value: groupId);
  }

  static Future<String?> getCustGroupId() async {
    return await _storage.read(key: _keyCustGroupId);
  }



}
