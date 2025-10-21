class VerifyOtpResponse {
  final String message;
  final int success;
  final VerifyOtpData? data;

  VerifyOtpResponse({
    required this.message,
    required this.success,
    this.data,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? 0,
      data: json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null,
    );
  }
}

class VerifyOtpData {
  final String message;
  final String statusOTP;

  VerifyOtpData({
    required this.message,
    required this.statusOTP,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      message: json['message'] ?? '',
      statusOTP: json['statusOTP'] ?? '',
    );
  }
}
