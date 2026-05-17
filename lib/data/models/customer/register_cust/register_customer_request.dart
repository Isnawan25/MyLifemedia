class RegisterCustomerRequest {
  final String customerName;
  final String customerPhone;
  final String email;
  final String customerAddress;
  final double latitude;
  final double longitude;

  final dynamic coverage;
  final String regionId;

  final int productId;
  final int productCategoryId;

  final dynamic divisionId;
  final dynamic referralCode;

  RegisterCustomerRequest({
    required this.customerName,
    required this.customerPhone,
    required this.email,
    required this.customerAddress,
    required this.latitude,
    required this.longitude,
    required this.coverage,
    required this.regionId,
    required this.productId,
    required this.productCategoryId,
    required this.divisionId,
    required this.referralCode,
  });

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "customer_phone": customerPhone,
    "email": email,
    "customer_address": customerAddress,
    "latitude": latitude,
    "longitude": longitude,
    "coverage": coverage,
    "region_id": regionId,
    "product_id": productId,
    "product_category_id": productCategoryId,
    "division_id": divisionId,
    "referral_code": referralCode,
  };
}