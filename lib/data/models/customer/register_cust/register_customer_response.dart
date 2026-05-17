class RegisterCustomerResponse {
  final String message;
  final int success;
  final RegisterCustomerData? data;

  RegisterCustomerResponse({
    required this.message,
    required this.success,
    this.data,
  });

  factory RegisterCustomerResponse.fromJson(
      Map<String, dynamic> json) {
    return RegisterCustomerResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? 0,
      data: json['data'] != null
          ? RegisterCustomerData.fromJson(json['data'])
          : null,
    );
  }
}

class RegisterCustomerData {
  final int id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double latitude;
  final double longitude;
  final String regionId;
  final int productId;
  final int productCategoryId;
  final String email;

  RegisterCustomerData({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.latitude,
    required this.longitude,
    required this.regionId,
    required this.productId,
    required this.productCategoryId,
    required this.email,
  });

  factory RegisterCustomerData.fromJson(
      Map<String, dynamic> json) {
    return RegisterCustomerData(
      id: json['id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      customerAddress: json['customer_address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      regionId: json['region_id'] ?? '',
      productId: json['product_id'] ?? 0,
      productCategoryId:
      json['product_category_id'] ?? 0,
      email: json['email'] ?? '',
    );
  }
}