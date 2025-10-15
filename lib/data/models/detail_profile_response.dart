class DetailProfileResponse {
  final String? status;
  final String? message;
  final DetailProfileData? data;

  DetailProfileResponse({this.status, this.message, this.data});

  factory DetailProfileResponse.fromJson(Map<String, dynamic> json) {
    return DetailProfileResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? DetailProfileData.fromJson(json['data'])
          : null,
    );
  }
}

class DetailProfileData {
  final String? custNumber;
  final String? custName;
  final String? custAddress;
  final String? custPhone;
  final String? custEmail;
  final String? custProvince;
  final String? custDistrict;
  final String? custSubDistrict;
  final String? custVillage;
  final String? status;

  DetailProfileData({
    this.custNumber,
    this.custName,
    this.custAddress,
    this.custPhone,
    this.custEmail,
    this.custProvince,
    this.custDistrict,
    this.custSubDistrict,
    this.custVillage,
    this.status,
  });

  factory DetailProfileData.fromJson(Map<String, dynamic> json) {
    return DetailProfileData(
      custNumber: json['cust_number'],
      custName: json['cust_name'],
      custAddress: json['cust_address'],
      custPhone: json['cust_phone'],
      custEmail: json['cust_email'],
      custProvince: json['cust_province'],
      custDistrict: json['cust_district'],
      custSubDistrict: json['cust_sub_district'],
      custVillage: json['cust_village'],
      status: json['status'],
    );
  }
}
