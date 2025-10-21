class DetailProfileResponse {
  final String message;
  final int success;
  final DetailProfileData? data;

  DetailProfileResponse({
    required this.message,
    required this.success,
    this.data,
  });

  factory DetailProfileResponse.fromJson(Map<String, dynamic> json) {
    return DetailProfileResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? 0,
      data: json['data'] != null
          ? DetailProfileData.fromJson(json['data'])
          : null,
    );
  }
}

class DetailProfileData {
  final String custNumber;
  final String custName;
  final String custAddress;
  final String custPhone;
  final String custEmail;

  DetailProfileData({
    required this.custNumber,
    required this.custName,
    required this.custAddress,
    required this.custPhone,
    required this.custEmail,
  });

  factory DetailProfileData.fromJson(Map<String, dynamic> json) {
    return DetailProfileData(
      custNumber: json['custNumber'] ?? '',
      custName: json['custName'] ?? '',
      custAddress: json['custAddress'] ?? '',
      custPhone: json['custPhone'] ?? '',
      custEmail: json['custEmail'] ?? '',
    );
  }
}
