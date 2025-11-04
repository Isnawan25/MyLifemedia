class LoginResponse {
  final String message;
  final bool success;
  final CustomerData? data;

  LoginResponse({
    required this.message,
    required this.success,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      success: json['success'] == 1,
      data: json['data'] != null ? CustomerData.fromJson(json['data']) : null,
    );
  }
}

class CustomerData {
  final String accessToken;
  final String custNumber;
  final String custName;
  final String custAddress;
  final String custPhone;
  final String custEmail;
  final String custGroupId;
  final String? custProvince;
  final String? custDistrict;
  final String? custSubDistrict;
  final String? custVillage;

  CustomerData({
    required this.accessToken,
    required this.custNumber,
    required this.custName,
    required this.custAddress,
    required this.custPhone,
    required this.custEmail,
    required this.custGroupId,
    this.custProvince,
    this.custDistrict,
    this.custSubDistrict,
    this.custVillage,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      accessToken: json['access_token'] ?? '',
      custNumber: json['custNumber'] ?? '',
      custName: json['custName'] ?? '',
      custAddress: json['custAddress'] ?? '',
      custPhone: json['custPhone'] ?? '',
      custEmail: json['custEmail'] ?? '',
      custGroupId: json['custGroupId'] ?? '',
      custProvince: json['custProvince'],
      custDistrict: json['custDistrict'],
      custSubDistrict: json['custSubDistrict'],
      custVillage: json['custVillage'],
    );
  }
}
