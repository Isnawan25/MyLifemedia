class OtpRequestResponse {
  final String? status;
  final String? message;

  OtpRequestResponse({this.status, this.message});

  factory OtpRequestResponse.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
