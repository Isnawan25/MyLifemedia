class OtpResponse {
  final String message;
  final bool success;
  final OtpData? data;

  OtpResponse({
    required this.message,
    required this.success,
    this.data,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'] ?? '',
      success: json['success'] == 1,
      data: json['data'] != null ? OtpData.fromJson(json['data']) : null,
    );
  }
}

class OtpData {
  final String otp;

  OtpData({required this.otp});

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      otp: json['otp'] ?? '',
    );
  }
}
