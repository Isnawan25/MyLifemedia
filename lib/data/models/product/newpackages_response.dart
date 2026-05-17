class NewPackagesResponse {
  final String message;
  final int success;
  final List<NewPackagesModel> data;

  NewPackagesResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory NewPackagesResponse.fromJson(Map<String, dynamic> json) {
    return NewPackagesResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NewPackagesModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class NewPackagesModel {
  final int productId;
  final String spCodeId;
  final String spCode;
  final String spName;
  final int spPrice;

  NewPackagesModel({
    required this.productId,
    required this.spCodeId,
    required this.spCode,
    required this.spName,
    required this.spPrice,
  });

  factory NewPackagesModel.fromJson(Map<String, dynamic> json) {
    return NewPackagesModel(
      productId: json['productId'] ?? 0,
      spCodeId: json['spCodeId'] ?? '',
      spCode: json['spCode'] ?? '',
      spName: json['spName'] ?? '',
      spPrice: json['spPrice'] ?? 0,
    );
  }
}