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

  static const _keyCustProvince = 'custProvince';
  static Future<void> saveCustProvince(String value) async =>
      await _storage.write(key: _keyCustProvince, value: value);
  static Future<String?> getCustProvince() async =>
      await _storage.read(key: _keyCustProvince);

  static const _keyCustDistrict = 'custDistrict';
  static Future<void> saveCustDistrict(String value) async =>
      await _storage.write(key: _keyCustDistrict, value: value);
  static Future<String?> getCustDistrict() async =>
      await _storage.read(key: _keyCustDistrict);

  static const _keyCustSubDistrict = 'custSubDistrict';
  static Future<void> saveCustSubDistrict(String value) async =>
      await _storage.write(key: _keyCustSubDistrict, value: value);
  static Future<String?> getCustSubDistrict() async =>
      await _storage.read(key: _keyCustSubDistrict);

  static const _keyCustVillage = 'custVillage';
  static Future<void> saveCustVillage(String value) async =>
      await _storage.write(key: _keyCustVillage, value: value);
  static Future<String?> getCustVillage() async =>
      await _storage.read(key: _keyCustVillage);

  static Future<void> saveCustName(String value) async =>
      await _storage.write(key: 'custName', value: value);
  static Future<void> saveCustPhone(String value) async =>
      await _storage.write(key: 'custPhone', value: value);
  static Future<void> saveCustEmail(String value) async =>
      await _storage.write(key: 'custEmail', value: value);
  static Future<void> saveCustAddress(String value) async =>
      await _storage.write(key: 'custAddress', value: value);

  // ==== GETTERS YANG DIBUTUHKAN ====
  static Future<String?> getCustName() async =>
      await _storage.read(key: 'custName');

  static Future<String?> getCustPhone() async =>
      await _storage.read(key: 'custPhone');

  static Future<String?> getCustEmail() async =>
      await _storage.read(key: 'custEmail');

  static Future<String?> getCustAddress() async =>
      await _storage.read(key: 'custAddress');
}
