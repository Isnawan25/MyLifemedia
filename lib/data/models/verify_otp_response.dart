class VerifyOtpResponse {
  final String? status;
  final String? message;
  final String? token; // jika nanti backend kasih token login

  VerifyOtpResponse({this.status, this.message, this.token});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['status'],
      message: json['message'],
      token: json['token'],
    );
  }
}
