class RegisterCustomerResponse {
  final String message;
  final int success;

  RegisterCustomerResponse({required this.message, required this.success});

  factory RegisterCustomerResponse.fromJson(Map<String, dynamic> json) {
    return RegisterCustomerResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? 0,
    );
  }
}
