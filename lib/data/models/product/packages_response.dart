class GetPackagesResponse {
  final String message;
  final int success;
  final List<PackageData> data;

  GetPackagesResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory GetPackagesResponse.fromJson(Map<String, dynamic> json) {
    return GetPackagesResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => PackageData.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class PackageData {
  final String spCodeId;
  final String spCode;
  final String spName;
  final int spPrice;

  PackageData({
    required this.spCodeId,
    required this.spCode,
    required this.spName,
    required this.spPrice,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
      spCodeId: json['spCodeId'] ?? '',
      spCode: json['spCode'] ?? '',
      spName: json['spName'] ?? '',
      spPrice: json['spPrice'] ?? 0,
    );
  }
}
