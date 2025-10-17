class DetailProfileResponse {
  final bool? success;
  final String? message;
  final DetailProfileData? data;

  DetailProfileResponse({
    this.success,
    this.message,
    this.data,
  });

  factory DetailProfileResponse.fromJson(Map<String, dynamic> json) {
    return DetailProfileResponse(
      success: json['success'] == 1 || json['success'] == true,
      message: json['message'],
      data: json['data'] != null
          ? DetailProfileData.fromJson(json['data'])
          : null,
    );
  }
}

class DetailProfileData {
  final String? accessToken;
  final String? custNumber;
  final String? custName;
  final String? custAddress;
  final String? custPhone;
  final String? custEmail;
  final String? custProvince;
  final String? custDistrict;
  final String? custSubDistrict;
  final String? custVillage;

  DetailProfileData({
    this.accessToken,
    this.custNumber,
    this.custName,
    this.custAddress,
    this.custPhone,
    this.custEmail,
    this.custProvince,
    this.custDistrict,
    this.custSubDistrict,
    this.custVillage,
  });

  factory DetailProfileData.fromJson(Map<String, dynamic> json) {
    return DetailProfileData(
      accessToken: json['access_token'] ?? '',
      custNumber: json['custNumber'] ?? '',
      custName: json['custName'] ?? '',
      custAddress: json['custAddress'] ?? '',
      custPhone: json['custPhone'] ?? '',
      custEmail: json['custEmail'] ?? '',
      custProvince: json['custProvince'],
      custDistrict: json['custDistrict'],
      custSubDistrict: json['custSubDistrict'],
      custVillage: json['custVillage'],
    );
  }
}
